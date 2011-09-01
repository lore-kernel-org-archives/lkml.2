Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1IAPeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:34:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47923 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1IAPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:33:59 -0400
Date: Thu, 01 Sep 2011 11:32:34 -0400 (EDT)
Message-Id: <20110901.113234.755815899606372879.davem@davemloft.net>
To: nmav@gnutls.org
Cc: herbert@gondor.hengli.com.au, phil@nwl.cc, cryptodev-linux-devel@gna.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAJU7zaKnKYYLx6W_9WsZCcwhNd0KMM9R8fs2D0=Xd_6T_AE4=A@mail.gmail.com>
References: <CAJU7za+OAusW-n9F4CLJNSAXVQTE2gxkdgpDFZb2tfys3EZspw@mail.gmail.com>
	<20110901145902.GA31834@gondor.apana.org.au>
	<CAJU7zaKnKYYLx6W_9WsZCcwhNd0KMM9R8fs2D0=Xd_6T_AE4=A@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Sep 2011 08:32:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Date: Thu, 1 Sep 2011 17:06:06 +0200

> It would be interesting to have a partial kernel-space TLS
> implementation but I don't know whether such a thing could ever make
> it to kernel.

Herbert and I have discussed this several times and we plan on
implementing this at some point.
