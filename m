Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348Ab2C2XPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:15:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:52972 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760171Ab2C2XPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:15:06 -0400
Date: Fri, 30 Mar 2012 10:11:32 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Subject: Re: [PATCH v17 00/15] seccomp_filter: BPF-based syscall filtering
In-Reply-To: <1333051320-30872-1-git-send-email-wad@chromium.org>
Message-ID: <alpine.LRH.2.02.1203301010310.11201@tundra.namei.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, Will Drewry wrote:

> Please see prior revisions for a detailed discussion of this patch
> series.
> 
> This series is a rebase on to:
>   b5174fa3a7f4f8f150bfa3b917c92608953dfa0f
> with very minor changes due to rebasing and tweaks noticed by a few
> initial users.  (I will rebase again for v3.4-rc1 when that time comes.)

I've offered to take this via my tree -- if anyone else wants to merge it 
via theirs instead, holler.

-- 
James Morris
<jmorris@namei.org>
