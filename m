Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2HTJwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:52:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52750 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2HTJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:52:34 -0400
Date: Mon, 20 Aug 2012 02:52:34 -0700 (PDT)
Message-Id: <20120820.025234.751280633665050946.davem@davemloft.net>
To: keguang.zhang@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: Re: [PATCH] net/stmmac: fix issue of clk_get for Loongson1B.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1345284983-12610-1-git-send-email-keguang.zhang@gmail.com>
References: <1345284983-12610-1-git-send-email-keguang.zhang@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kelvin Cheung <keguang.zhang@gmail.com>
Date: Sat, 18 Aug 2012 18:16:23 +0800

> When getting clock, give a chance to the CPUs without DT support,
> which use Common Clock Framework, such as Loongson1B.
> 
> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>

Applied, thanks.
