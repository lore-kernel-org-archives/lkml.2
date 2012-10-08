Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab2JHMDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:03:03 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40911 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JHMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:03:00 -0400
Date: Mon, 8 Oct 2012 08:03:44 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/7] uio_pruss cleanup and platform support
Message-ID: <20121008120344.GQ11149@beef>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
 <5072B190.1060200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5072B190.1060200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:27:20PM +0530, Sekhar Nori wrote:
> On 10/5/2012 10:34 PM, Matt Porter wrote:
> 
> > This series enables uio_pruss on DA850 and removes use of the
> > private SRAM API by the driver. The driver previously was not
> > enabled by any platform and the private SRAM API was accessing
> > an invalid SRAM bank.
> > 
> > It is regression tested on AM180x EVM with suspend/resume due
> > to the new use of the shared SRAM for both PM and PRUSS. The
> > uio_pruss driver is tested on the same platform using the
> > PRU_memAccessPRUDataRam and PRU_memAccessL3andDDR examples from
> > the PRU userspace tools available from http://www.ti.com/tool/sprc940
> 
> I applied patches 2/7, 3/7 and 6/7 of this series for v3.8. I have some
> comments on the board patch. Rest of the patches depend on acceptance of
> 1/7 so I will take them only after that is accepted.

Ok, thanks...and I'll post a v5 of 5/7 and 7/7 and those should be ready
when 1/7 is accepted.

-Matt
