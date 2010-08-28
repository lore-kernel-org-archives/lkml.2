Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0H1W2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 18:28:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51749
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab0H1W2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 18:28:18 -0400
Date: Sat, 28 Aug 2010 15:28:34 -0700 (PDT)
Message-Id: <20100828.152834.183037846.davem@davemloft.net>
To: peterz@infradead.org
Cc: aarcange@redhat.com, avi@redhat.com, tglx@linutronix.de, riel@redhat.com,
        mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, benh@kernel.crashing.org,
        hugh.dickins@tiscali.co.uk, mel@csn.ul.ie, npiggin@kernel.dk,
        paulmck@linux.vnet.ibm.com, yanmin_zhang@linux.intel.com,
        sfr@canb.auug.org.au
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283005928.1975.3548.camel@laptop>
References: <20100828141637.421594670@chello.nl>
	<1283005928.1975.3548.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I get 'as' segfaults during a "make -j128" of the kernel on sparc64
with these changes.

I'll try to track it down.
