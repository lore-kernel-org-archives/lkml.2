Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1KVPde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:33:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36509 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1KVPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:33:33 -0500
Date: Tue, 22 Nov 2011 07:33:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111122153326.GD322@google.com>
References: <4EC4F2FB.408@parallels.com>
 <20111121225019.GQ25776@google.com>
 <4ECB8346.8040806@parallels.com>
 <201111221204.39235.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111221204.39235.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 22, 2011 at 12:04:38PM +0000, Pedro Alves wrote:
> This whole userspace C/R stuff and being able to set the child's pid has potential
> of being very useful for GDB too, allowing a much better reimplementation of its
> old checkpointing feature [*], and allowing for a faster reverse debugging
> implementation, by being able to do faster rewinding -- restore snapshot and replay
> instructions up to N (by single stepping or running to breakpoint), rather than
> manually undoing the effects of each instruction, one by one.
> 
> IOW, root only would be a shame from GDB's perspective.

Would CAP_CHECKPOINT be a shame too?  I'm reluctant about priviledge
through fd inheritance mostly because of its unusualness.  I don't
think priv management is a good problem space for small creative
solutions.  We're much better off with mundane mechanisms which people
are already familiar with and is easy to account for.

Thank you.

-- 
tejun
