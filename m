Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1B1ALu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 19:11:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40021
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab1B1ALt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 19:11:49 -0500
Date: Sun, 27 Feb 2011 16:12:25 -0800 (PST)
Message-Id: <20110227.161225.200373200.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        herbert@gondor.hengli.com.au, nhorman@tuxdriver.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [V4 PATCH 3/3] bond: service netpoll arp queue on master device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298022215-21059-3-git-send-email-amwang@redhat.com>
References: <1298022215-21059-1-git-send-email-amwang@redhat.com>
	<1298022215-21059-3-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Fri, 18 Feb 2011 17:43:34 +0800

> Neil pointed out that we can't send ARP reply on behalf of slaves,
> we need to move the arp queue to their bond device.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Applied.
