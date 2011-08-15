Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1HOFrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:47:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39218 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1HOFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:47:20 -0400
Date: Sun, 14 Aug 2011 22:47:14 -0700 (PDT)
Message-Id: <20110814.224714.2061635645365376268.davem@davemloft.net>
To: jun.kondo@ctc-g.co.jp
Cc: linux-kernel@vger.kernel.org, omega-g1@ctc-g.co.jp, notsuki@redhat.com,
        motokazu.kozaki@hp.com, htaira@redhat.com, netdev@vger.kernel.org,
        tomohiko.takahashi@ctc-g.co.jp, kotaro.sakai@ctc-g.co.jp,
        ken.sugawara@ctc-g.co.jp
Subject: Re: [PATCH] net: configurable sysctl parameter
 "net.core.tcp_lowat" for sk_stream_min_wspace()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E48B0C3.2010203@ctc-g.co.jp>
References: <4E48B0C3.2010203@ctc-g.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 14 Aug 2011 22:47:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Date: Mon, 15 Aug 2011 14:38:11 +0900

> 2. to limit the block time of the write in order to
> prevent the timeout of upper layer applications
> even when the connection has low throughput, such
> as low rate streaming

Use non-blocking writes if you want this behavior.
