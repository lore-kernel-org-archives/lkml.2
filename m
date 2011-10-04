Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736Ab1JDU0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:26:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55875 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab1JDU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:26:23 -0400
Date: Tue, 04 Oct 2011 16:26:16 -0400 (EDT)
Message-Id: <20111004.162616.1293120763854321339.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Subject: Re: [PATCH 2/3] NET: fix phy init for Asix AX88178 USB (GigE)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317758118-24052-2-git-send-email-grundler@chromium.org>
References: <1317758118-24052-1-git-send-email-grundler@chromium.org>
	<1317758118-24052-2-git-send-email-grundler@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 04 Oct 2011 13:26:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>
Date: Tue,  4 Oct 2011 12:55:17 -0700

> Asix provided this patch and I've confirmed "Plugable USB2-E1000" and
> "Shenzhen Winstars NWU220G" USB dongles can get a link and TX/RX data.
> 
> Signed-off-by: "Freddy Xin" <freddy@asix.com.tw>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Applied to net-next-2.6
