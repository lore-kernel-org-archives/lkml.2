Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1FTUxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:53:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34861 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1FTUxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:53:11 -0400
Date: Mon, 20 Jun 2011 13:52:43 -0700 (PDT)
Message-Id: <20110620.135243.1585031042472945043.davem@davemloft.net>
To: vitalivanov@gmail.com
Cc: jj@chaosbits.net, netdev@vger.kernel.org, segoon@openwall.com,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH][Trivial]: ipv4, ping: Remove duplicate icmp.h include
From: David Miller <davem@davemloft.net>
In-Reply-To: <415E440A-6C7F-4ADB-AE81-05AEAD5C3269@gmail.com>
References: <alpine.LNX.2.00.1106201028340.18991@swampdragon.chaosbits.net>
	<20110620.130515.1956879930278498236.davem@davemloft.net>
	<415E440A-6C7F-4ADB-AE81-05AEAD5C3269@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Jun 2011 13:52:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Mon, 20 Jun 2011 23:50:38 +0300

> It's already in Jiri's trivial tree.

And now it's in mine, no harm :-)
