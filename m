Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1GPRxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 13:53:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1GPRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 13:53:37 -0400
Date: Sat, 16 Jul 2011 10:46:36 -0700 (PDT)
Message-Id: <20110716.104636.222054324515998844.davem@davemloft.net>
To: simoneau@ele.uri.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sun4m SMP: fix wrong shift instruction in IPI handler
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110716030515.GA13614@ele.uri.edu>
References: <20110716030515.GA13614@ele.uri.edu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 16 Jul 2011 10:47:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Simoneau <simoneau@ele.uri.edu>
Date: Fri, 15 Jul 2011 23:05:15 -0400

> This shift instruction appears to be shifting in the wrong direction.
> Without this change, my SparcStation-20MP hangs just after bringing up
> the second CPU:
> 
> Entering SMP Mode...
> Starting CPU 2 at f02b4e90
> Brought up 2 CPUs
> Total of 2 processors activated (99.52 BogoMIPS).
>    *** stuck ***
> 
> Signed-off-by: Will Simoneau <simoneau@ele.uri.edu>

Applied, thanks a lot Will.
