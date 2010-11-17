Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316Ab0KQSzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:55:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60556
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935059Ab0KQSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:55:37 -0500
Date: Wed, 17 Nov 2010 10:56:00 -0800 (PST)
Message-Id: <20101117.105600.179937042.davem@davemloft.net>
To: eparis@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
        equinox@diac24.net, eric.dumazet@gmail.com, hzhong@gmail.com,
        jmorris@namei.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
        paul.moore@hp.com, pekkas@netcore.fi, sds@tycho.nsa.gov,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 2/3] network: tcp_connect should return certain errors
 up the stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101116215249.6727.89763.stgit@paris.rdu.redhat.com>
References: <20101116215238.6727.39248.stgit@paris.rdu.redhat.com>
	<20101116215249.6727.89763.stgit@paris.rdu.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Tue, 16 Nov 2010 16:52:49 -0500

> The current tcp_connect code completely ignores errors from sending an skb.
> This makes sense in many situations (like -ENOBUFFS) but I want to be able to
> immediately fail connections if they are denied by the SELinux netfilter hook.
> Netfilter does not normally return ECONNREFUSED when it drops a packet so we
> respect that error code as a final and fatal error that can not be recovered.
> 
> Based-on-patch-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied.
