Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab0DZUmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:42:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57731
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232Ab0DZUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:42:01 -0400
Date: Mon, 26 Apr 2010 13:42:07 -0700 (PDT)
Message-Id: <20100426.134207.229746269.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: arnd@arndb.de, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, viro@zeniv.linux.org.uk, jblunck@suse.de,
       mingo@elte.hu, jkacur@redhat.com
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org>
	<201004261030.21751.arnd@arndb.de>
	<alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Apr 2010 11:08:39 -0700 (PDT)

> NOTE! This has gone through a "allmodconfig" (with staging drivers), but 
> only on x86-64. There are quite probably missing architecture conversions
> and/or drivers. But this should be the bulk of them.

"allmodconfig" on sparc64 passes with this patch too, just FYI...
