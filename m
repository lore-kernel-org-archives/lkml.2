Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0ENITA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:19:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:34646 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0ENIS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:18:58 -0400
Subject: Re: [PATCH 11/35] lmb: Add find_memory_core_early()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECEF07.8020700@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-12-git-send-email-yinghai@kernel.org>
	 <1273804173.21352.386.camel@pasglop>  <4BECEF07.8020700@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:16:39 +1000
Message-ID: <1273824999.21352.587.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:34 -0700, Yinghai wrote:
> 
> it is calling __lmb_find_area()
> 
> but it need to use early_node_map[], so put this function here

The prototype still has nothing to do in lmb.h

You are just doing those horrible API conversions with slight name
changes, it's just insane. Just use the proper API or change it if it
doesn't suit you (and justify yourself), but stop doing all those weirdo
wrappers.

Ben.


