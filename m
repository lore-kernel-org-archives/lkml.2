Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0ENIde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:33:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:59178 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab0ENIda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:33:30 -0400
Subject: Re: [PATCH 17/35] x86, lmb: Add x86 version of __lmb_find_area()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECF21C.7030006@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-18-git-send-email-yinghai@kernel.org>
	 <1273804466.21352.400.camel@pasglop>  <4BECF21C.7030006@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:31:24 +1000
Message-ID: <1273825884.21352.603.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:47 -0700, Yinghai wrote:

> for safe, and there is any problem with top to down allocation, we can
> ask user to check if low to high works...
> 
> not just make user to get broken kernel.

Hrm. That's a bit gross. But ok, I don't care that much as long as your
x86 variant doesn't differ in semantics with the core lmb one and I'll
let Peter and/or Thomas to scream at you if they think it's gross
(hint: the code is)

Cheers,
Ben.


