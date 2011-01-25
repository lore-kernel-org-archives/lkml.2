Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1AYU3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:29:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42948
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166Ab1AYU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:29:32 -0500
Date: Tue, 25 Jan 2011 12:30:05 -0800 (PST)
Message-Id: <20110125.123005.193713229.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: aarcange@redhat.com, avi@redhat.com, tglx@linutronix.de, riel@redhat.com,
        mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
        npiggin@kernel.dk, paulmck@linux.vnet.ibm.com,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 04/25] sparc: Preemptible mmu_gather
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110125174907.390914415@chello.nl>
References: <20110125173111.720927511@chello.nl>
	<20110125174907.390914415@chello.nl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 25 Jan 2011 18:31:15 +0100

> Rework the sparc mmu_gather usage to conform to the new world order :-)
> 
> Sparc mmu_gather does two things:
>  - tracks vaddrs to unhash
>  - tracks pages to free
> 
> Split these two things like powerpc has done and keep the vaddrs
> in per-cpu data structures and flush them on context switch.
> 
> The remaining bits can then use the generic mmu_gather.
> 
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: David S. Miller <davem@davemloft.net>
