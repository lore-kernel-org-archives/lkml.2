Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0JNVqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:46:17 -0400
Received: from xenotime.net ([72.52.115.56]:34961 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755993Ab0JNVqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:46:16 -0400
Date: Thu, 14 Oct 2010 14:46:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        agruen@suse.de, davem@davemloft.net, andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
Message-Id: <20101014144613.0dbb8da0.rdunlap@xenotime.net>
In-Reply-To: <20101014143723.ffea0d8c.akpm@linux-foundation.org>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
	<20101014125458.9e51ac58.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
	<20101014143723.ffea0d8c.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 14:37:23 -0700 Andrew Morton wrote:

> > (See v2.6.24-6165-gc82a5cb)
> 
> hm, what does that mean.
> --

v2.6.24 + 6165 changesets, with c82a5cb being the last commit:

> git show c82a5cb | more
commit c82a5cb8b2b2ce15f1fb8add6772921b72da5943
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 31 03:57:36 2008 -0800

    linux/types.h: Use __u64 for aligned_u64

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
