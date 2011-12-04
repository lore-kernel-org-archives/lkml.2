Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1LDTAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:00:38 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38347 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab1LDTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:34 -0500
Date: Sun, 04 Dec 2011 14:00:12 -0500 (EST)
Message-Id: <20111204.140012.2039227798298276086.davem@davemloft.net>
To: thomas@m3y3r.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: Use kmemdup rather than duplicating its
 implementation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321569820.1624.274.camel@localhost.localdomain>
References: <1321569820.1624.274.camel@localhost.localdomain>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 04 Dec 2011 11:00:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>
Date: Thu, 17 Nov 2011 23:43:40 +0100

> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Applied.
