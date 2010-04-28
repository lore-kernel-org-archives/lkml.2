Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab0D1WjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:39:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:33773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0D1WjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:39:07 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <201004281406.04080.arnd@arndb.de>
References: <1272429513.24542.83.camel@pasglop>
	 <201004281406.04080.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 08:35:21 +1000
Message-ID: <1272494121.24542.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 14:06 +0200, Arnd Bergmann wrote:
> 
> This needs to use time_before() to avoid problems on jiffies
> wraparound.

Ah right, forgot about that, been a while I didn't use jiffies for
anything :-)

I'll respin later today.

Cheers,
Ben.

