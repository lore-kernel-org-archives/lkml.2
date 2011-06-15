Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1FOXbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 19:31:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab1FOXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 19:31:38 -0400
Date: Wed, 15 Jun 2011 16:31:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/3] atomic: use <linux/atomic.h>
Message-Id: <20110615163115.773d072e.akpm@linux-foundation.org>
In-Reply-To: <1307381251-15729-1-git-send-email-asharma@fb.com>
References: <1307381251-15729-1-git-send-email-asharma@fb.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I didn't merge patch #3.  With patches 1 & 2 applied, i386 allnoconfig:


  CC      arch/x86/kernel/asm-offsets.s
In file included from /usr/src/devel/arch/x86/include/asm/atomic.h:321,
                 from include/linux/atomic.h:3,
                 from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets.c:8:
include/asm-generic/atomic-long.h: In function 'atomic_long_add_unless':
include/asm-generic/atomic-long.h:246: error: implicit declaration of function 'atomic_add_unless'
In file included from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/atomic.h: At top level:
include/linux/atomic.h:14: error: static declaration of 'atomic_add_unless' follows non-static declaration
include/asm-generic/atomic-long.h:246: note: previous implicit declaration of 'atomic_add_unless' was here
