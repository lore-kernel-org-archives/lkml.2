Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab2JHLEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:04:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51855 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2JHLEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:04:53 -0400
Message-ID: <5072B33E.2010205@ti.com>
Date: Mon, 8 Oct 2012 16:34:30 +0530
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
Subject: Re: [PATCH v4 6/7] ARM: davinci: clean up DA850 EVM include ordering
References: <1349456686-22736-1-git-send-email-mporter@ti.com> <1349456686-22736-7-git-send-email-mporter@ti.com>
In-Reply-To: <1349456686-22736-7-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2012 10:34 PM, Matt Porter wrote:
> Reorder includes so they are grouped by linux/mach/asm
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

Thanks for the clean-up. While committing, I changed the subject to:

"ARM: davinci: da850 evm: clean up include ordering"

which is the convention I prefer.

Thanks,
Sekhar
