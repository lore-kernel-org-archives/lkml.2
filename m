Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2LCBdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:33:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33662 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2LCBdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:33:11 -0500
Date: Sun, 02 Dec 2012 20:33:09 -0500 (EST)
Message-Id: <20121202.203309.1858145449914043352.davem@davemloft.net>
To: tipecaml@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        rmody@brocade.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] bna: remove useless calls to memset().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354416022-20189-2-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
	<1354416022-20189-2-git-send-email-tipecaml@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Roelandt <tipecaml@gmail.com>
Date: Sun,  2 Dec 2012 03:40:17 +0100

> These calls are followed by calls to memcpy() on the same memory area, so they
> can safely be removed.
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

Applied, thanks.
