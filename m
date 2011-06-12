Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1FLBEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 21:04:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44979 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1FLBEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 21:04:40 -0400
Date: Sat, 11 Jun 2011 18:04:36 -0700 (PDT)
Message-Id: <20110611.180436.2125878475128439464.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, minipli@googlemail.com, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikU44wjhzSLxP9XPcpsfkhQaGhayw@mail.gmail.com>
References: <20110611234415.GE11521@ZenIV.linux.org.uk>
	<20110611.175834.1802167158365693401.davem@davemloft.net>
	<BANLkTikU44wjhzSLxP9XPcpsfkhQaGhayw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 18:04:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Jun 2011 18:01:06 -0700

> We always had the unconditional "set_fs()" in the exec path. It only
> got moved, and as part of that conscious effort, the pointless
> architecture churn is getting cleaned up.

Sure.
