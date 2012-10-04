Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2JDVwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:52:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53542 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2JDVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:51:58 -0400
Date: Thu, 4 Oct 2012 14:51:54 -0700 (PDT)
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
In-Reply-To: <506CD7C6.2000500@att.net>
Message-ID: <alpine.DEB.2.00.1210041450530.11776@chino.kir.corp.google.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-7-git-send-email-daniel.santos@pobox.com> <alpine.DEB.2.00.1210022344180.12717@chino.kir.corp.google.com> <506C2636.6020304@att.net> <alpine.DEB.2.00.1210031122020.2412@chino.kir.corp.google.com>
 <506CD7C6.2000500@att.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Daniel Santos wrote:

> I have it checked out from git://git.cmpxchg.org/linux-mmotm.git, the
> problem is that I cannot correctly test against that right now because I
> get an oops (without my patches) when setting up LVM (same on -next, bug
> report here https://bugzilla.kernel.org/show_bug.cgi?id=48241).  What
> I'm thinking about doing is to rebase them against v3.6 again and test
> them there, but it will require a few minor changes (due to walken's
> patches not being present).  Still, it's better than no re-testing.
> Daniel
> 

I would cherry-pick the changes you already have for this patchset in -mm 
into Linus' latest tree, then base your new patchset on top of that 
modified tree.
