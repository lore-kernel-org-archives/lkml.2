Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab1COVEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:04:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41282
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758729Ab1COVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:04:15 -0400
Date: Tue, 15 Mar 2011 14:04:52 -0700 (PDT)
Message-Id: <20110315.140452.48500353.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: mingo@elte.hu, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        Trond.Myklebust@netapp.com, vladislav.yasevich@hp.com, sri@us.ibm.com,
        viro@zeniv.linux.org.uk, eparis@redhat.com, menage@google.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, johannes@sipsolutions.net,
        linville@tuxdriver.com, hadi@cyberus.ca, jpirko@redhat.com,
        eric.dumazet@gmail.com, hagen@jauu.net, randy.dunlap@oracle.com,
        jkosina@suse.cz, joe@perches.com, u.kleine-koenig@pengutronix.de,
        ebiederm@xmission.com, gregkh@suse.de, xemul@openvz.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 17/17] net,act_police,rcu: remove rcu_barrier()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D7F3B62.6000005@cn.fujitsu.com>
References: <4D7F3610.6000809@cn.fujitsu.com>
	<4D7F3B62.6000005@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 15 Mar 2011 18:11:46 +0800

> 
> 
> There is no callback of this module maybe queued
> since we use kfree_rcu(), we can safely remove the rcu_barrier().
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
