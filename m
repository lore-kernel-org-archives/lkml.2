Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1FKWIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 18:08:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58325 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab1FKWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 18:08:22 -0400
Date: Sat, 11 Jun 2011 15:07:06 -0700 (PDT)
Message-Id: <20110611.150706.985438181862065028.davem@davemloft.net>
To: cmdkhh@gmail.com
Cc: bp@alien8.de, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: signedness warning fix again
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306993925-26044-1-git-send-email-cmdkhh@gmail.com>
References: <1306993925-26044-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 15:07:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Connor Hansen <cmdkhh@gmail.com>
Date: Wed,  1 Jun 2011 22:52:05 -0700

> One of the legit warnings 'make W=3 drivers/ide/ide-cd.c'
> generates is:
> drivers/ide/ide-cd.c: In function ide_cd_do_request
> drivers/ide/ide-cd.c:828:2: warning: conversion to int from \
> unsigned int may change the sign of the result
> drivers/ide/ide-cd.c:833:2: warning: conversion to int from \
> unsigned int may change the sign of the result
> 
> nsectors is declared int, should be unsigned int.
> 
> blk_rq-sectors() returns unsigned int, and ide_complete_rq
> expects unsigned int as well.  Fixes both warnings.
> 
> Signed-off-by: Connor Hansen <cmdkhh@gmail.com>

Applied, thanks.
