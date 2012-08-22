Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2HVCaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:30:21 -0400
Received: from ozlabs.org ([203.10.76.45]:33201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab2HVCaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:30:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Richard Weinberger <richard@nod.at>, David Howells <dhowells@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
In-Reply-To: <5033C8DF.2080403@xenotime.net>
References: <502A69FA.8040805@nod.at> <502A6759.3090802@nod.at> <15981.1344955883@warthog.procyon.org.uk> <502A613F.1090600@nod.at> <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net> <15532.1344954413@warthog.procyon.org.uk> <18600.1344956051@warthog.procyon.org.uk> <18933.1344956788@warthog.procyon.org.uk> <30102.1344957328@warthog.procyon.org.uk> <502A6BF8.6040804@nod.at> <502A8DD6.90807@xenotime.net> <878vda5l8s.fsf@rustcorp.com.au> <5033C8DF.2080403@xenotime.net>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 22 Aug 2012 10:47:35 +0930
Message-ID: <874nnv3ets.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012 10:43:59 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 08/19/2012 07:51 PM, Rusty Russell wrote:
> 
> > On Tue, 14 Aug 2012 10:41:42 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >> On 08/14/2012 08:17 AM, Richard Weinberger wrote:
> >>
> >>> Am 14.08.2012 17:15, schrieb David Howells:
> >>>> How about this then?
> >>>>
> >>>> David
> >>>> ---
> >>>> diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
> >>>> index 9926e11..a4b0c10 100644
> >>>> --- a/arch/x86/um/Kconfig
> >>>> +++ b/arch/x86/um/Kconfig
> >>>> @@ -21,9 +21,11 @@ config 64BIT
> >>>>  config X86_32
> >>>>  	def_bool !64BIT
> >>>>  	select HAVE_AOUT
> >>>> +	select MODULES_USE_ELF_REL
> >>>>  
> >>>>  config X86_64
> >>>>  	def_bool 64BIT
> >>>> +	select MODULES_USE_ELF_RELA
> >>>>  
> >>>>  config RWSEM_XCHGADD_ALGORITHM
> >>>>  	def_bool X86_XADD && 64BIT
> >>>
> >>> Looks sane.
> >>>
> >>> Acked-by: Richard Weinberger <richard@nod.at>
> >>
> >>
> >> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Thanks, folded into David's original patch.
> 
> 
> When will this be fixed in linux-next?
> 
> linux-next of 20120821 still fails.

Should be in latest, ie. 20120822.

Cheers,
Rusty.
