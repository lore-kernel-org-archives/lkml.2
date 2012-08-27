Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2H0SVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:21:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38614 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2H0SVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:21:46 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, ncardwell@google.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <503BB49C.5010402@lwfinger.net>
References: <50369925.3050705@lwfinger.net>
	 <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>
	 <20120824.111948.680531915905273128.davem@davemloft.net>
	 <5037A4B0.3080208@lwfinger.net>
	 <1345825095.19483.19.camel@edumazet-glaptop>
	 <1345825432.19483.20.camel@edumazet-glaptop> <5037B2AC.50704@lwfinger.net>
	 <1345830424.19483.69.camel@edumazet-glaptop>
	 <503BB49C.5010402@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Aug 2012 11:21:41 -0700
Message-ID: <1346091701.26634.6.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-27 at 12:55 -0500, Larry Finger wrote:

> I have prepared a patch to fix all the unchecked allocations.
> 
> Over the weekend I made some progress. To test the latest vendor driver, I 
> installed a 32-bit system. Their driver is not compatible with a 64-bit system. 
> I found that not only did the vendor driver work with secure sites, but so did 
> the in-kernel version. I now have tcpdump output for the 32-bit case that works, 
> and the 64-bit case that fails. It seems likely that I missed some 32/64 bit 
> incompatibility when I did the conversion.
> 
> Thanks for all your help in trying to resolve this issue.

Interesting, so these 32/64 bits problems did not happen in prior
kernels ? (< 3.4 )


