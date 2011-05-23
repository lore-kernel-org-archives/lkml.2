Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1EWRWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:22:42 -0400
Received: from service87.mimecast.com ([94.185.240.25]:60857 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932076Ab1EWRWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:22:41 -0400
Subject: Re: [PATCH v5 00/19] ARM: Add support for the Large Physical
 Address Extensions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110523165412.GF15138@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <20110523165412.GF15138@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 23 May 2011 18:22:34 +0100
Message-ID: <1306171354.7196.30.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 23 May 2011 17:22:47.0314 (UTC) FILETIME=[08E3B720:01CC196E]
X-MC-Unique: 111052318223800801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 17:54 +0100, Russell King - ARM Linux wrote:
> On Sun, May 08, 2011 at 01:51:19PM +0100, Catalin Marinas wrote:
> > This set of patches adds support for the Large Physical Extensions on
> > the ARM architecture (available with the Cortex-A15 processor). LPAE
> > comes with a 3-level page table format (compared to 2-level for the
> > classic one), allowing up to 40-bit physical address space.
> >
> > The ARM LPAE documentation is available from (free registration needed):
> >
> > http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html
> >
> > The full set of patches on top of linux-next (LPAE, support for an
> > emulated Versatile Express with Cortex-A15 tile and generic timers) is
> > available on this branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae-next
> 
> FYI, I'm going to drop the pgt patch because the warnings are still there
> and I _still_ don't feel happy about pushing that into mainline and then
> being endlessly bugged about it.

I haven't seen the warnings but probably because I applied the LPAE
patches on top. I'll have a look as well.

> So I'll drop it from my tree again and re-merge that branch after this
> window has closed.

OK. In the meantime I'll cherry-pick it into my LPAE branch based on
mainline. As we discussed, after -rc1 I plan to push the LPAE patches to
-next. Your patch would come from two different sources but I'm not sure
whether git can cope with it (given that I rename files like pgtable.h).
The alternative would be to base my patches on your branch as long as
you don't rebase it.

-- 
Catalin


