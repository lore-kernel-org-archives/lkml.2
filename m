Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1JASOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:14:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53372 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab1JASOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:14:16 -0400
Date: Sat, 01 Oct 2011 14:13:43 -0400 (EDT)
Message-Id: <20111001.141343.2293070262147973147.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: w@1wt.eu, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111001180641.GD6309@home.goodmis.org>
References: <20110930235924.GA25176@kroah.com>
	<20111001073533.GA18690@1wt.eu>
	<20111001180641.GD6309@home.goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 01 Oct 2011 11:13:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 1 Oct 2011 14:06:41 -0400

> For my machine that is connected to the outside world, I have a script
> that runs every night that checks for attacks. As bots constantly look
> for port 22 and 80, they find my machine without issue. When my script
> detects a bunch of ssh login attempts that fail, it will add that ip
> address to the iptables DROP chain:

By running sshd on a different port, you'll avoid the login attempts
as well as the overhead of the successful connection attempts.

I haven't allowed sshd to run on port 22 in more than 10 years.
