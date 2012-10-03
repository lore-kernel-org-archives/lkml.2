Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2JCPgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:36:09 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42477 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab2JCPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:36:08 -0400
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.46.74
Date: Wed, 3 Oct 2012 08:35:58 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/10] bug.h: Replace __linktime_error with
 __compiletime_error
Message-ID: <20121003153558.GB7192@leaf>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-7-git-send-email-daniel.santos@pobox.com>
 <alpine.DEB.2.00.1210022344180.12717@chino.kir.corp.google.com>
 <506C2636.6020304@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C2636.6020304@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 06:49:10AM -0500, Daniel Santos wrote:
> On 10/03/2012 01:44 AM, David Rientjes wrote:
> > On Fri, 28 Sep 2012, Daniel Santos wrote:
> >
> >> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> > After this is folded into the previous patch in the series, 
> > "compiler{,-gcc4}.h: Remove duplicate macros", then:
> >
> > 	Acked-by: David Rientjes <rientjes@google.com>
> Thanks.  I've actually just reversed the patch order per Josh's
> suggestion and added patch comments to it.  I can squash them if you
> guys prefer.
> 
> Unfortunately, I'm a bit confused as to how I should re-submit these,
> still being new to this project.  Patch 1 is already in -mm. Patches 2-3
> have not changed. I've made a correction to patch #4 and reversed the
> order of 5 & 6. And what was 8-10 is now 8-15, as I've completely
> re-done BUILD_BUG_ON.  I was planning on just submitting the whole set
> again, is this the correct protocol?  If so, should I reply to the
> original [PATCH 0/10] thread or create a new one?

Make your cover letter a reply to the original PATCH 0/10 mail,
generate your patches with git format-patch --subject-prefix=PATCHv2 ,
and include in the cover letter a patch series changelog saying what
changed in v2.

- Josh Triplett
