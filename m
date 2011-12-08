Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1LHE4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:56:13 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52184 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1LHE4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:56:12 -0500
Date: Wed, 07 Dec 2011 23:56:02 -0500 (EST)
Message-Id: <20111207.235602.1465915988125994516.davem@davemloft.net>
To: artisdom@gmail.com
Cc: jpirko@redhat.com, jwboyer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipip, sit: copy parms.name after register_netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAM7b5hyXkRTUwnE-NwXEff-34WjRfMSBDf2itMVhdJGi4XoA=g@mail.gmail.com>
References: <CAM7b5hzt8D6hn3=XEcm9E3_BwJxj-YABpkufCpuhjiPLDxCsMQ@mail.gmail.com>
	<20111206173220.GA28763@kroah.com>
	<CAM7b5hyXkRTUwnE-NwXEff-34WjRfMSBDf2itMVhdJGi4XoA=g@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Dec 2011 20:56:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ted Feng <artisdom@gmail.com>
Date: Thu, 8 Dec 2011 11:35:15 +0800

> @@ -285,6 +285,8 @@ static struct ip_tunnel *
> ipip_tunnel_locate(struct net *net,

Your patches are corrupted by your email client and unusable.
