Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2JHK5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:57:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36660 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2JHK5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:57:49 -0400
Message-ID: <5072B190.1060200@ti.com>
Date: Mon, 8 Oct 2012 16:27:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v4 0/7] uio_pruss cleanup and platform support
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
In-Reply-To: <1349456686-22736-1-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2012 10:34 PM, Matt Porter wrote:

> This series enables uio_pruss on DA850 and removes use of the
> private SRAM API by the driver. The driver previously was not
> enabled by any platform and the private SRAM API was accessing
> an invalid SRAM bank.
> 
> It is regression tested on AM180x EVM with suspend/resume due
> to the new use of the shared SRAM for both PM and PRUSS. The
> uio_pruss driver is tested on the same platform using the
> PRU_memAccessPRUDataRam and PRU_memAccessL3andDDR examples from
> the PRU userspace tools available from http://www.ti.com/tool/sprc940

I applied patches 2/7, 3/7 and 6/7 of this series for v3.8. I have some
comments on the board patch. Rest of the patches depend on acceptance of
1/7 so I will take them only after that is accepted.

Thanks,
Sekhar
