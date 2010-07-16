Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966117Ab0GPT5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:57:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32817
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450Ab0GPT5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:57:35 -0400
Date: Fri, 16 Jul 2010 12:57:51 -0700 (PDT)
Message-Id: <20100716.125751.173840884.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] vhost-net fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100716122530.GA29478@redhat.com>
References: <20100716122530.GA29478@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 16 Jul 2010 15:25:30 +0300

> David, please pull the following fixes for 2.6.35.
> Thanks!
> 
> The following changes since commit 91a72a70594e5212c97705ca6a694bd307f7a26b:
> 
>   net/core: neighbour update Oops (2010-07-14 18:02:16 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net
> 
> Michael S. Tsirkin (2):
>       vhost-net: avoid flush under lock
>       vhost: avoid pr_err on condition guest can trigger

Pulled, thanks!
