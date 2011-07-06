Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1GFDpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:45:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35225 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab1GFDpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:45:51 -0400
Date: Tue, 05 Jul 2011 20:45:46 -0700 (PDT)
Message-Id: <20110705.204546.433639330355698050.davem@davemloft.net>
To: joe@perches.com
Cc: zambrano@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b44: Use pr_<level>_once and DRV_DESCRIPTION
From: David Miller <davem@davemloft.net>
In-Reply-To: <c57bb53427d6b56cf18ef7302033e58ef5eb92fb.1309887804.git.joe@perches.com>
References: <c57bb53427d6b56cf18ef7302033e58ef5eb92fb.1309887804.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 05 Jul 2011 20:45:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue,  5 Jul 2011 10:43:46 -0700

> Convert a printk with a static to pr_<level>_once
> Add and use DRV_DESCRIPTION to reduce string duplication.
> Remove now unused version.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
