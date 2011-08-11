Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1HKMxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:53:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46981 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1HKMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:53:48 -0400
Date: Thu, 11 Aug 2011 05:53:40 -0700 (PDT)
Message-Id: <20110811.055340.41728083700098314.davem@davemloft.net>
To: julia@diku.dk
Cc: error27@gmail.com, paul@paul-moore.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netlabel/netlabel_kapi.c: add missing cleanup code
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1108111205450.18938@ask.diku.dk>
References: <20110811094407.GG3777@shale.localdomain>
	<Pine.LNX.4.64.1108111152130.18938@ask.diku.dk>
	<Pine.LNX.4.64.1108111205450.18938@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 05:53:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 11 Aug 2011 12:06:04 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> Call cipso_v4_doi_putdef in the case of the failure of the allocation of
> entry.  Reverse the order of the error handling code at the end of the
> function and insert more labels in order to reduce the number of
> unnecessary calls to kfree.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
