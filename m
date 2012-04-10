Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2DJJt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:49:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:51179 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab2DJJtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:49:55 -0400
Date: Tue, 10 Apr 2012 19:48:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: Indan Zupancic <indan@nul.nu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v17 08/15] seccomp: add system call filtering using BPF
In-Reply-To: <CABqD9hYE0S4EL6yH-57SfNs+D8GFKJgWVN21VzXpQmRuh2ow=w@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1204101948330.28663@tundra.namei.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org> <1333051320-30872-9-git-send-email-wad@chromium.org> <20120406132330.457a05cf.akpm@linux-foundation.org> <67e30a0c8655fc53a92e8138bba9de66.squirrel@webmail.greenhost.nl>
 <CABqD9hYE0S4EL6yH-57SfNs+D8GFKJgWVN21VzXpQmRuh2ow=w@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Will Drewry wrote:

> > seccomp_chk_filter() mirrors sk_chk_filter(). So it refers to
> > "chk", not "check".
> 
> I can change it to be written out or leave it matching the networking
> code.  Any preferences?

check :-)


-- 
James Morris
<jmorris@namei.org>
