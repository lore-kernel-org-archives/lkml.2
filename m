Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab0EJVyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:54:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:35748 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0EJVyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:54:05 -0400
Subject: Re: [PATCH 03/25] lmb: Introduce for_each_lmb() and new accessors,
 and use it
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
In-Reply-To: <alpine.LFD.2.00.1005101735560.3401@localhost.localdomain>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-2-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-3-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
	 <alpine.LFD.2.00.1005101735560.3401@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 07:52:52 +1000
Message-ID: <1273528372.23699.108.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:39 +0200, Thomas Gleixner wrote:
> Can you please make this:
> 
> #define for_each_lmb(lmb_type, region, __iter)                          \
>         for (__iter = lmb.lmb_type.regions;                             \
>              region < (lmb.lmb_type.regions + lmb.lmb_type.cnt);        \
>              region++)
> 
> so we do not have the iterator name hardcoded inside the macro body.

Oops, you are right, that's a thinko. I'll fix that.

Cheers,
Ben.


