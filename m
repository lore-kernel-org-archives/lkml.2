Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab2JCS0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:26:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51293 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216Ab2JCS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:26:34 -0400
Date: Wed, 3 Oct 2012 11:26:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Santos <daniel.santos@pobox.com>
cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
In-Reply-To: <506C2636.6020304@att.net>
Message-ID: <alpine.DEB.2.00.1210031122020.2412@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-7-git-send-email-daniel.santos@pobox.com> <alpine.DEB.2.00.1210022344180.12717@chino.kir.corp.google.com> <506C2636.6020304@att.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Daniel Santos wrote:

> Thanks.  I've actually just reversed the patch order per Josh's
> suggestion and added patch comments to it.  I can squash them if you
> guys prefer.
> 

No need to be so fine-grained in your patches, if you're trying to replace 
__linktime_error with __compiletime_error, which happens to be the title 
of the patch (and should remain the title), then just remove it's single 
occurrence and its definition at the same time with a clear changelog that 
__compiletime_error is sufficient.  No need to have two small patches with 
the same motivation.

> Unfortunately, I'm a bit confused as to how I should re-submit these,
> still being new to this project.  Patch 1 is already in -mm. Patches 2-3
> have not changed. I've made a correction to patch #4 and reversed the
> order of 5 & 6. And what was 8-10 is now 8-15, as I've completely
> re-done BUILD_BUG_ON.  I was planning on just submitting the whole set
> again, is this the correct protocol?  If so, should I reply to the
> original [PATCH 0/10] thread or create a new one?
> 

You already have a patch in -mm, so you have to base your series on that 
tree.  Get the latest -mm tree from http://www.ozlabs.org/~akpm/mmotm/ and 
base the revised series on that tree, then send it off to 
Andrew Morton <akpm@linux-foundation.org> and cc the list and your 
reviewers.  People often find it helpful to make it clear that this is v2 
of the patchset and that it's based on -mm as a helpful pointer.
