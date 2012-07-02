Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2GBBe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:34:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52818 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2GBBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:34:25 -0400
Date: Sun, 01 Jul 2012 18:34:24 -0700 (PDT)
Message-Id: <20120701.183424.373435067959587069.davem@davemloft.net>
To: Milo.Kim@ti.com
Cc: arnd@arndb.de, linux-omap@vger.kernel.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, mathieu.poirier@linaro.org
Subject: Re: [PATCH] ethernet: add export.h in davinci_cpdma.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120701.183333.353465166541062775.davem@davemloft.net>
References: <A874F61F95741C4A9BA573A70FE3998FCAAB@DQHE02.ent.ti.com>
	<20120701.183333.353465166541062775.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also, networking patches should always be CC:'d to netdev@vger.kernel.org
