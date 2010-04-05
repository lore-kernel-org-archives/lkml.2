Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0DEUqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:46:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59652
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219Ab0DEUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:46:45 -0400
Date: Mon, 05 Apr 2010 13:46:47 -0700 (PDT)
Message-Id: <20100405.134647.48384289.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100405194055.GA5265@nowhere>
References: <20100405065701.GC5127@nowhere>
	<20100405.122233.188421941.davem@davemloft.net>
	<20100405194055.GA5265@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 5 Apr 2010 21:40:58 +0200

> It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> when the function tracer runs). And I hadn't your perf_arch_save_caller_regs()
> when I triggered this.

Good clues, thanks.
