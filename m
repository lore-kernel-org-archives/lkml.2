Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1LHJML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:12:11 -0500
Received: from ozlabs.org ([203.10.76.45]:53294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1LHJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:12:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock debugging
In-Reply-To: <1323268258.18450.11.camel@deadeye>
References: <1323268258.18450.11.camel@deadeye>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 08 Dec 2011 15:00:25 +1030
Message-ID: <8762hrit26.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Dec 2011 14:30:58 +0000, Ben Hutchings <ben@decadent.org.uk> wrote:
> We do want to allow lock debugging for GPL-compatible modules that are
> not (yet) built in-tree.  This was disabled as a side-effect of commit
> 2449b8ba0745327c5fa49a8d9acffe03b2eded69 ('module,bug: Add
> TAINT_OOT_MODULE flag for modules not built in-tree').  Lock debug
> warnings now include taint flags, so kernel developers should still
> be able to deflect warnings caused by out-of-tree modules.
> 
> The TAINT_PROPRIETARY_MODULE flag for non-GPL-compatible modules will
> still disable lock debugging.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Meh.  Disabling lock debugging was always a weird thing to do, IMHO.
Taint flags should be used for warnings to developers, not these strange
side-effects.

Cheers,
Rusty.
