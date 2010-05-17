Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0EQSKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:10:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46160 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0EQSK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:10:27 -0400
Message-ID: <4BF18500.60105@zytor.com>
Date: Mon, 17 May 2010 11:03:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Yinghai <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/35] lmb: prepare x86 to use lmb to replace early_res
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-2-git-send-email-yinghai@kernel.org>	 <1273803143.21352.353.camel@pasglop>  <4BECEB8D.8070600@oracle.com> <1273824578.21352.579.camel@pasglop>
In-Reply-To: <1273824578.21352.579.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:09 AM, Benjamin Herrenschmidt wrote:
> 
> No. That is not the point. Read the rest of my email !
> 
> We need to -sanitize- those errors. _Maybe_ exposing LMB_ERROR is the
> right way to do so, but in that case, we need to make -all- function use
> the same error code. Right now, some fail with 0 and some with
> LMB_ERROR.
> 

Using errnos like the rest of the kernel seems like the right thing to
do, IMO.

	-hpa
