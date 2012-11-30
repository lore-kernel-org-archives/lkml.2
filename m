Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031393Ab2K3R2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:28:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512Ab2K3R2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:28:15 -0500
Date: Fri, 30 Nov 2012 12:28:13 -0500 (EST)
Message-Id: <20121130.122813.1136966656907114890.davem@davemloft.net>
To: jslaby@suse.cz
Cc: maxk@qti.qualcomm.com, netdev@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: fix bouncing tun/tap entries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354295140-6355-1-git-send-email-jslaby@suse.cz>
References: <1354295140-6355-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 30 Nov 2012 18:05:40 +0100

> Delivery to the following recipient failed permanently:
> 
>      vtun@office.satix.net
> 
> Technical details of permanent failure:
> DNS Error: Domain name not found
> 
> Of course:
> $ host office.satix.net
> Host office.satix.net not found: 3(NXDOMAIN)
> 
> ===========
> 
> And "Change of Email Address Notification":
> Old Address        New Address           Email Subject
> ------------------------------------------------------
> maxk@qualcomm.com  maxk@qti.qualcomm.com "tuntap: multiqueue...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Applied.
