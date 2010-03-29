Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0C2Xf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:35:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:36759 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0C2Xf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:35:56 -0400
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB12BBA.4060108@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>
	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>
	 <1269901252.2286.11.camel@concordia>  <4BB12BBA.4060108@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 10:34:24 +1100
Message-ID: <1269905664.7101.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 15:37 -0700, Yinghai Lu wrote:
> > We just need a lmb.alloc_limit and a lmb_set_alloc_limit() which arch
> > code calls when it knows what the alloc limit is (and can call multiple
> > times during boot). Or maybe it should be called "default_alloc_limit",
> > but that's getting a bit long winded.
> 
> ok, I will get_max_mapped() for now, an will change to new field...later

No. Do it now. get_max_mapped() sucks as an identifier.

Cheers,
Ben.

 

