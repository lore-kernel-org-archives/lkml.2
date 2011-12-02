Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab1LBCt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:49:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40856 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab1LBCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:49:26 -0500
Date: Thu, 01 Dec 2011 21:46:41 -0500 (EST)
Message-Id: <20111201.214641.1764261585752810377.davem@davemloft.net>
To: panweiping3@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: flush route cache after change accept_local
From: David Miller <davem@davemloft.net>
In-Reply-To: <ea4d82977e7726dccd8e8f8e65c7fb523668100e.1322790334.git.panweiping3@gmail.com>
References: <20111201.125200.1219939487021672308.davem@davemloft.net>
	<ea4d82977e7726dccd8e8f8e65c7fb523668100e.1322790334.git.panweiping3@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Dec 2011 18:46:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weiping Pan <panweiping3@gmail.com>
Date: Fri,  2 Dec 2011 09:47:06 +0800

> After reset ipv4_devconf->data[IPV4_DEVCONF_ACCEPT_LOCAL] to 0,
> we should flush route cache, or it will continue receive packets with local
> source address, which should be dropped.
> 
> Signed-off-by: Weiping Pan <panweiping3@gmail.com>

Applied, thanks.
