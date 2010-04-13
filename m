Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab0DMFx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:53:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53085 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0DMFxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:53:24 -0400
Message-ID: <4BC4053D.2050805@zytor.com>
Date: Mon, 12 Apr 2010 22:46:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/39] lmb: Add lmb_find_area()
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>	 <1270793048-23796-8-git-send-email-yinghai@kernel.org>	 <1271131543.13059.53.camel@pasglop>  <4BC3F317.7030702@oracle.com> <1271135239.13059.69.camel@pasglop> <4BC40074.6030604@oracle.com>
In-Reply-To: <4BC40074.6030604@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:26 PM, Yinghai wrote:
> 
> current generic lmb_find_area() is allocating from high to low.
> x86 32bit seems have problem with that.

Presumably because it fills up ZONE_DMA.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

