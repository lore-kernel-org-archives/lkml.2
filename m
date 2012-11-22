Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2KVSwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:52:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50756 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2KVSwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:52:24 -0500
Date: Thu, 22 Nov 2012 14:44:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 0/9] Cleanup & new features for compiler*.h and bug.h
Message-ID: <20121122134410.GE17147@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
	Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:42:03PM -0600, danielfsantos@att.net wrote:
> 
>  include/linux/bug.h           |   47 ++++++++++++++++++++++------------------
>  include/linux/compiler-gcc.h  |    3 ++
>  include/linux/compiler-gcc3.h |    8 +++---
>  include/linux/compiler-gcc4.h |   28 ++++++++++++------------
>  include/linux/compiler.h      |   32 +++++++++++++++++++++++++--
>  5 files changed, 76 insertions(+), 42 deletions(-)

Ok,

this patchset is slowly but surely getting into a mergeable state and
could probably use wider testing in linux-next right about now.

Maybe akpm can pick it up into -mm so that it sees -next and then if all
is fine maybe find its way upstream in the next merge window, AFAICT.

Thanks.

-- 
Regards/Gruss,
Boris.
