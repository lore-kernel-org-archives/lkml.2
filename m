Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966018Ab2DLUQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:16:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41217 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965873Ab2DLUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:16:50 -0400
Date: Thu, 12 Apr 2012 16:15:15 -0400 (EDT)
Message-Id: <20120412.161515.268929016632579152.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6/ipv6_sockglue.c: Removed redundant extern
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334083887-5375-1-git-send-email-eldad@fogrefinery.com>
References: <1334083887-5375-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 13:15:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Tue, 10 Apr 2012 20:51:27 +0200

> extern int sysctl_mld_max_msf is already defined in linux/ipv6.h.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied, thanks.
