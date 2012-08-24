Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689Ab2HXQBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:01:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44762 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2HXQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:01:39 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5037A292.1020801@lwfinger.net>
References: <50345B12.1050600@lwfinger.net>
	 <1345612503.5158.566.camel@edumazet-glaptop>
	 <50355021.7000408@lwfinger.net> <1345694593.5904.87.camel@edumazet-glaptop>
	 <50369925.3050705@lwfinger.net>
	 <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>
	 <1345820142.4824.1.camel@edumazet-laptop> <5037A292.1020801@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Aug 2012 18:01:34 +0200
Message-ID: <1345824094.19483.9.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 10:49 -0500, Larry Finger wrote:

> There is nothing in kernel log when it happens. The file STRACE is attached.
> 

So there is indeed a corruption. What was the driver you used in this
case ?


