Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0EJVzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:55:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:35766 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab0EJVzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:55:35 -0400
Subject: Re: [PATCH 05/22] lmb: Add lmb_reserve_area/lmb_free_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BE84BE7.1020404@oracle.com>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-6-git-send-email-yinghai@kernel.org>
	 <1273475438.23699.74.camel@pasglop>  <4BE84BE7.1020404@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 07:53:42 +1000
Message-ID: <1273528422.23699.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 11:09 -0700, Yinghai wrote:
> those functions have __init markers, and only can be used on boot
> stage. so do need to worry about hotplug mem.
> 
> what I do is: use current lmb code for x86, and keep the affects to
> original lmb users to minimum. (should be near 0)

But that's just wrong. You are just duplicating functionality all over
the place. That doesn't make any sense.

Cheers,
Ben.


