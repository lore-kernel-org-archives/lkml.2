Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1A2Qf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 11:35:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63974 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1A2Qf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 11:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=xCQltCWtQyZzr/+BAMjuNKf8nfKysFsGt8YNyWum9/WrqPU0ip815ku/hbIj9h/O+u
         2AL2Ht4f/ibxpamtwNSLCY96SvKNdRrgsZ9zQE3/F1MdjOQJuts8DSCmjL4WRTsdSQCL
         9mAaRBc56+i9kRW4mIQccbMF3n46iQULu8AgA=
Cc: trivial@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Message-Id: <C8696C82-BB0E-4F18-B971-3C288BBE3E5A@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <20110129095045.GA1842@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] arch:arm:mbox-db5500.c Change initate to initiate.
Date: Sat, 29 Jan 2011 08:35:05 -0800
References: <1296244040-3653-1-git-send-email-justinmattock@gmail.com> <20110129095045.GA1842@n2100.arm.linux.org.uk>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29, 2011, at 1:50 AM, Russell King - ARM Linux wrote:

> On Fri, Jan 28, 2011 at 11:47:20AM -0800, Justin P. Mattock wrote:
>> Not sure if this is a typo or not. if it is then feel free to take  
>> this.
>
> You should copy the maintainers for this platform:
>
> ARM/Ux500 ARM ARCHITECTURE
> M:      Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> M:      Linus Walleij <linus.walleij@stericsson.com>
> L:      linux-arm-kernel@lists.infradead.org (moderated for non- 
> subscribers)
> S:      Maintained
> F:      arch/arm/mach-ux500/
> F:      drivers/dma/ste_dma40*
> F:      drivers/mfd/ab3550*
> F:      drivers/mfd/abx500*
> F:      drivers/mfd/ab8500*
> F:      drivers/mfd/stmpe*
> F:      drivers/rtc/rtc-ab8500.c
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/ 
> linux-stericsson.git


alright.. I added them to the Cc..

Justin P. Mattock
