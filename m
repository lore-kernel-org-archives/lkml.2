Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2DIDtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 23:49:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:60575 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab2DIDtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 23:49:31 -0400
Date: Mon, 9 Apr 2012 13:48:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com,
        Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v17 00/15] seccomp_filter: BPF-based syscall filtering
In-Reply-To: <20120406142846.fd8dea70.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.02.1204091348060.16214@tundra.namei.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org> <alpine.LRH.2.02.1203301010310.11201@tundra.namei.org> <20120406142846.fd8dea70.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Andrew Morton wrote:

> > I've offered to take this via my tree -- if anyone else wants to merge it 
> > via theirs instead, holler.
> 
> OK by me, especially if it means that you'll carefully (re)review it!  I
> had some minor quibbles with v17.

Sure.

> 
> It would be good if Oleg could take a look at the signal changes, if he
> has not yet done so?
> 

-- 
James Morris
<jmorris@namei.org>
