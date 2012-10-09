Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2JITqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:46:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46179 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JITqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:46:02 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Tue, 9 Oct 2012 12:45:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Santos <daniel.santos@pobox.com>,
        Daniel Santos <danielfsantos@att.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-ID: <20121009194551.GA3616@jtriplet-mobl1>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
 <1349466169-20637-3-git-send-email-daniel.santos@pobox.com>
 <20121006231041.GB3278@liondog.tnic>
 <5071C9AE.2010106@att.net>
 <20121009114158.9cdf1378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009114158.9cdf1378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:41:58AM -0700, Andrew Morton wrote:
> On Sun, 07 Oct 2012 13:27:58 -0500
> Daniel Santos <danielfsantos@att.net> wrote:
> 
> > We'll have to ask Andrew.  Maybe so he can test on those versions of gcc?
> > 
> > commit d3ffe64a1dbcfe18b57f90f7c01c40c93d0a8b92
> > Author: Andrew Morton <akpm@linux-foundation.org>
> > Date:   Fri Sep 28 00:02:42 2012 +0000
> > 
> >     a
> >    
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> > index 934bc34..997fd8a 100644
> > --- a/include/linux/compiler-gcc4.h
> > +++ b/include/linux/compiler-gcc4.h
> > @@ -5,7 +5,7 @@
> >  /* GCC 4.1.[01] miscompiles __weak */
> >  #ifdef __KERNEL__
> >  # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> > -#  error Your version of gcc miscompiles the __weak directive
> > +//#  error Your version of gcc miscompiles the __weak directive
> 
> hm, yeah, sorry, I use various old crufty cross-compilers.

Ah, for build testing where you don't actually care if the resulting
kernel runs?

- Josh Triplett
