Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1EXKEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:04:21 -0400
Received: from service87.mimecast.com ([94.185.240.25]:33138 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753187Ab1EXKES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:04:18 -0400
Subject: Re: [PATCH v5 00/19] ARM: Add support for the Large Physical
 Address Extensions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110523165412.GF15138@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <20110523165412.GF15138@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Tue, 24 May 2011 11:04:08 +0100
Message-ID: <1306231448.19557.23.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 24 May 2011 10:04:22.0813 (UTC) FILETIME=[F49924D0:01CC19F9]
X-MC-Unique: 111052411041409801
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

What warnings are you seeing? Could you please post them?

I tried with just your nopud patch on top of v2.6.39 and compiled for
vexpress. I don't get any warnings and I tried STRICT_MM_TYPECHECKS as
well.

-- 
Catalin


