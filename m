Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab1EaWZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:25:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab1EaWZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:25:01 -0400
Date: Tue, 31 May 2011 15:23:46 -0700 (PDT)
Message-Id: <20110531.152346.160925902.davem@davemloft.net>
To: cmdkhh@gmail.com
Cc: bp@alien8.de, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ide-cd: Fix signedness warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306739612-29239-1-git-send-email-cmdkhh@gmail.com>
References: <1306739612-29239-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 15:23:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Connor Hansen <cmdkhh@gmail.com>
Date: Mon, 30 May 2011 00:13:32 -0700

> One of the legit warnings 'make W=3 drivers/ide/ide-cd.o´ generates is
> 
> drivers/ide/ide-cd.c: In function .ide_cdrom_prep_fs.:
> drivers/ide/ide-cd.c:1314: warning: conversion to .unsigned int. from .int. may change the sign of the result
> 
> because queue_logical_block_size() returns unsigned short but hard_sect
> is defined as int. Fix that no matter how low the potential for this
> becoming a bug is.
> 
> Signed-off-by: Connor Hansen <cmdkhh@gmail.com>

An 'int' can always hold as large a value as an "unsigned short" can ever
hold, so there is no real problem here.

I'm not applying this.
