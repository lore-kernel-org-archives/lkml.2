Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0K1T1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:27:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56234
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab0K1T1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:27:20 -0500
Date: Sun, 28 Nov 2010 11:27:47 -0800 (PST)
Message-Id: <20101128.112747.35051709.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL net-2.6] vhost-net: rcu fixup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101125122301.GA15990@redhat.com>
References: <20101125122301.GA15990@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 25 Nov 2010 14:23:01 +0200

> Please merge the following fix for 2.6.36.
> Thanks!
> 
> The following changes since commit a27e13d370415add3487949c60810e36069a23a6:
> 
>   econet: fix CVE-2010-3848 (2010-11-24 11:51:47 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net
> 
> Michael S. Tsirkin (1):
>       vhost/net: fix rcu check usage
> 

Pulled, thanks Michael.
