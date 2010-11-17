Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935291Ab0KQSzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:55:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60544
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935176Ab0KQSza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:55:30 -0500
Date: Wed, 17 Nov 2010 10:55:54 -0800 (PST)
Message-Id: <20101117.105554.102552958.davem@davemloft.net>
To: eparis@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
        equinox@diac24.net, eric.dumazet@gmail.com, hzhong@gmail.com,
        jmorris@namei.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
        paul.moore@hp.com, pekkas@netcore.fi, sds@tycho.nsa.gov,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 1/3] netfilter: allow hooks to pass error code back up
 the stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101116215238.6727.39248.stgit@paris.rdu.redhat.com>
References: <20101116215238.6727.39248.stgit@paris.rdu.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Tue, 16 Nov 2010 16:52:38 -0500

> SELinux would like to pass certain fatal errors back up the stack.  This patch
> implements the generic netfilter support for this functionality.
> 
> Based-on-patch-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied.
