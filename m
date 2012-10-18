Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2JRC1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:27:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37197 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2JRC1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:27:00 -0400
Date: Wed, 17 Oct 2012 19:26:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Santos <daniel.santos@pobox.com>
cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v2 01/10] compiler-gcc4.h: Reorder macros based upon gcc
 ver
In-Reply-To: <5070703F.8050004@att.net>
Message-ID: <alpine.DEB.2.00.1210171926230.30443@chino.kir.corp.google.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com> <1349466169-20637-1-git-send-email-daniel.santos@pobox.com> <20121006174220.GB6110@liondog.tnic> <5070703F.8050004@att.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012, Daniel Santos wrote:

> These are based against -mm, where another commit is already in that
> changes it.  I was told that since that commit was already in -mm, to
> not include it in the patch set:
> 
> 6c620cf1536a0ce6a83ecaaaf05298dcc0f7d440 (committed 2012-09-27)
> 
> This was probably (at least partially) the result of the fiasco I had
> with my email.
> 

Yeah, this patch applies fine on linux-next, which is the correct thing to 
do if you're building upon already queued patches.
