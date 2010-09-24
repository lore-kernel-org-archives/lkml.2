Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0IXUBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:01:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42487
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034Ab0IXUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:01:38 -0400
Date: Fri, 24 Sep 2010 13:01:58 -0700 (PDT)
Message-Id: <20100924.130158.246527937.davem@davemloft.net>
To: mfm@muteddisk.com
Cc: kernel-janitors@vger.kernel.org, sjur.brandeland@stericsson.com, j@w1.fi,
        linville@tuxdriver.com, dsd@gentoo.org, kune@deine-taler.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/24] net: change to new flag variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
References: <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
	<e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
	<facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>
Date: Fri, 24 Sep 2010 12:17:25 -0700

> Replace EXTRA_CFLAGS with ccflags-y.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>

Acked-by: David S. Miller <davem@davemloft.net>
