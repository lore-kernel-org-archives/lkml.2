Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1CaNhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:37:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56570 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab1CaNhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:37:54 -0400
Message-ID: <4D9483AD.2060604@monstr.eu>
Date: Thu, 31 Mar 2011 15:37:49 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: John Williams <john.williams@petalogix.com>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu> <1301574600-4861-2-git-send-email-monstr@monstr.eu> <20110331124925.GA2202@pengutronix.de> <AANLkTi=sG6oVNifwLLi8jjKQXjR6kXZx43NxtFfoPumy@mail.gmail.com> <20110331132328.GB2202@pengutronix.de>
In-Reply-To: <20110331132328.GB2202@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
>>    Maybe I misunderstand you, in my view it is the responsibility of <vendor>
>>    to create their DTS files to indicate they want <special-card1> to bind to
>>    generic-uio.
> 
> Device tree is a OS-neutral hardware description language. "generic-uio"
> is neither OS-neutral nor a hardware description. devicetree.org has
> more information about this.

If you look at dts for ppc you should be able to find out linux,stdout-path in 
chosen node. The same is for bootargs which are linux specific option.
If chosem node can be used for OS specific description then this could be a way.

M



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
