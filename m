Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0JTEvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:51:05 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42337 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0JTEvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:51:01 -0400
Date: Tue, 19 Oct 2010 21:45:39 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH V10] RO/NX protection for loadable kernel modules
Message-ID: <20101020044539.GX6311@outflux.net>
References: <817ecb6f1002011539g3f30416fi60c7c5222cab8f3@mail.gmail.com>
 <201002021429.38331.rusty@rustcorp.com.au>
 <4B67C0F9.2020202@zytor.com>
 <201002081159.45219.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002081159.45219.rusty@rustcorp.com.au>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 08, 2010 at 11:59:44AM +1030, Rusty Russell wrote:
> On Tue, 2 Feb 2010 04:36:49 pm H. Peter Anvin wrote:
> > On 02/01/2010 07:59 PM, Rusty Russell wrote:
> > > On Tue, 2 Feb 2010 10:09:53 am Siarhei Liakh wrote:
> > >> This patch is a logical extension of the protection provided by
> > >> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> > >> module_core and module_init into three logical parts each and setting
> > >> appropriate page access permissions for each individual section:
> > >>
> > >>   1. Code: RO+X
> > >>   2. RO data: RO+NX
> > >>   3. RW data: RW+NX
> > >
> > > Thanks, applied!
> > 
> > I also applied this to the -tip tree... do you prefer to carry it or 
> > should I leave it as is?
> 
> I'm always happy for you to do my work for me!  There are no other module
> patches likely to conflict.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Sorry for losing track, but where did this patch end up? I don't see it
in any of the trees I've looked in.

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
