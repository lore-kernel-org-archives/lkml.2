Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2FDEsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:48:42 -0400
Received: from ozlabs.org ([203.10.76.45]:54972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab2FDEsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:48:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <bp@amd64.org>, Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] init: Drop initcall level output
In-Reply-To: <1338569760-28859-1-git-send-email-bp@amd64.org>
References: <1338569760-28859-1-git-send-email-bp@amd64.org>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jun 2012 12:58:58 +0930
Message-ID: <87lik321s5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Jun 2012 18:56:00 +0200, Borislav Petkov <bp@amd64.org> wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> 9fb48c744ba6a ("params: add 3rd arg to option handler callback
> signature") added similar lines to dmesg:
> 
> initlevel:0=early, 4 registered initcalls
> initlevel:1=core, 31 registered initcalls
> initlevel:2=postcore, 11 registered initcalls
> initlevel:3=arch, 7 registered initcalls
> initlevel:4=subsys, 40 registered initcalls
> initlevel:5=fs, 30 registered initcalls
> initlevel:6=device, 250 registered initcalls
> initlevel:7=late, 35 registered initcalls
> 
> but they don't contain any info for the general user staring at dmesg.
> I'm very doubtful the count of initcalls registered per level helps
> anyone so drop that output completely.
> 
> Cc: Jim Cromie <jim.cromie@gmail.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jason Baron <jbaron@redhat.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Agreed and applied.

Thanks!
Rusty.
