Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2HFUsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:48:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39241 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2HFUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:48:42 -0400
Date: Mon, 06 Aug 2012 13:48:41 -0700 (PDT)
Message-Id: <20120806.134841.1602071497040501263.davem@davemloft.net>
To: samuel@sortiz.org
Cc: lliubbo@gmail.com, axel.lin@gmail.com, rmk+kernel@arm.linux.org.uk,
        gregkh@linuxfoundation.org, kuninori.morimoto.gx@renesas.com,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        sonic.zhang@analog.com, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] drivers: net: irda: bfin_sir: fix compile error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344247026.11031.27.camel@sortiz-mobl>
References: <1343630652-7220-1-git-send-email-lliubbo@gmail.com>
	<CAA_GA1d=mXhcOh7UL+8thMcz8ueQ4PR1Ytz8KNj40=+py+X7tA@mail.gmail.com>
	<1344247026.11031.27.camel@sortiz-mobl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Networking patches not sent to netdev will not be properly queued up
and tracked, and therefore will not be applied.
