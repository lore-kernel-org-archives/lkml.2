Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab2ETIKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 04:10:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55872 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2ETIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 04:09:59 -0400
Date: Sun, 20 May 2012 04:07:11 -0400 (EDT)
Message-Id: <20120520.040711.1958974633833486664.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4/ipconfig: neaten __setup placement
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337472279-18615-1-git-send-email-eldad@fogrefinery.com>
References: <1337472279-18615-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 May 2012 01:07:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun, 20 May 2012 02:04:39 +0200

> The __setup macro should follow the corresponding setup handler.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied.
