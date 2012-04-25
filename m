Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2DYMuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:50:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37608 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2DYMuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:50:21 -0400
Message-ID: <1335358206.28150.265.camel@twins>
Subject: Re: [PATCH 1/2] math128: Introduce {mult,add,cmp}_u128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 25 Apr 2012 14:50:06 +0200
In-Reply-To: <20120425112244.894997253@chello.nl>
References: <20120425111552.665217867@chello.nl>
	 <20120425112244.894997253@chello.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 13:15 +0200, Peter Zijlstra wrote:
> +static inline u128 add_u128(u128 a, u128 b)
> +{
> +       a.lo += b.lo;
> +       if (a.lo < b.lo)
> +               a.hi++;
> +
> +       return a;
> +} 

D'0h I lost a .hi add there..
