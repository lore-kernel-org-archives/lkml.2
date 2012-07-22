Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2GVTTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:19:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37999 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2GVTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:19:43 -0400
Date: Sun, 22 Jul 2012 12:19:42 -0700 (PDT)
Message-Id: <20120722.121942.2002727319293471163.davem@davemloft.net>
To: mst@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, asias@redhat.com,
        nab@linux-iscsi.org, nab@risingtidesystems.com, pbonzini@redhat.com,
        stefanha@gmail.com, stefanha@linux.vnet.ibm.com, wuzhy@cn.ibm.com
Subject: Re: [PULL] vhost-net changes for net/3.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120721225436.GA23519@redhat.com>
References: <20120721225436.GA23519@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 22 Jul 2012 01:54:36 +0300

> The following changes since commit 186e868786f97c8026f0a81400b451ace306b3a4:
> 
>   forcedeth: spin_unlock_irq in interrupt handler fix (2012-07-20 16:18:36 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next
> 
> for you to fetch changes up to 163049aefdc04323a2d17ec9f2862027b43b0502:
> 
>   vhost: make vhost work queue visible (2012-07-22 01:22:23 +0300)

Pulled, thanks.
