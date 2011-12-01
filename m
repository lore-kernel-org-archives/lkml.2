Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1LARyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:54:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36397 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1LARyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:54:43 -0500
Date: Thu, 01 Dec 2011 12:52:00 -0500 (EST)
Message-Id: <20111201.125200.1219939487021672308.davem@davemloft.net>
To: panweiping3@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ipv4: flush route cache after change accept_local
From: David Miller <davem@davemloft.net>
In-Reply-To: <1e224b52de77dcd5f994c8e4c77c780c6996e4a4.1322740026.git.panweiping3@gmail.com>
References: <1e224b52de77dcd5f994c8e4c77c780c6996e4a4.1322740026.git.panweiping3@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Dec 2011 09:52:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weiping Pan <panweiping3@gmail.com>
Date: Thu,  1 Dec 2011 19:47:56 +0800

> +		if ((i == IPV4_DEVCONF_ACCEPT_LOCAL - 1))

I don't think the extra parenthesis is appropriate here, please only use
one set of them.

Thanks.
