Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1HOGHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:07:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58476 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1HOGHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:07:37 -0400
Date: Sun, 14 Aug 2011 23:05:29 -0700 (PDT)
Message-Id: <20110814.230529.611834234177280886.davem@davemloft.net>
To: shawn.guo@freescale.com
Cc: shawn.guo@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110815060708.GH7244@S2100-06.ap.freescale.net>
References: <1313371817-5135-1-git-send-email-shawn.guo@linaro.org>
	<20110814.224341.2228974983062837890.davem@davemloft.net>
	<20110815060708.GH7244@S2100-06.ap.freescale.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 14 Aug 2011 23:05:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Guo <shawn.guo@freescale.com>
Date: Mon, 15 Aug 2011 14:07:09 +0800

> Can you please help me a little bit more with the "other places"?

arch/sparc/kernel/prom*.c
