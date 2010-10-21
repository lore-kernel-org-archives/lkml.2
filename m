Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0JUIIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:08:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44478
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab0JUIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:08:36 -0400
Date: Thu, 21 Oct 2010 01:08:59 -0700 (PDT)
Message-Id: <20101021.010859.71110203.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL net-2.6] vhost-net: access_ok fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101019145901.GA16025@redhat.com>
References: <20101019145901.GA16025@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 19 Oct 2010 16:59:01 +0200

> David,
> Not sure if it's too late for 2.6.36 - in case it's not, the following tree
> includes a last minute bugfix for vhost-net, found by code inspection.
> It is on top of net-2.6.
> Thanks!
> 
> The following changes since commit b0057c51db66c5f0f38059f242c57d61c4741d89:
> 
>   tg3: restore rx_dropped accounting (2010-10-11 16:06:24 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Even though it's too late, I've pulled this.
