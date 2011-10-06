Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab1JFTn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:43:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33852 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183Ab1JFTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:43:24 -0400
Date: Thu, 06 Oct 2011 15:41:17 -0400 (EDT)
Message-Id: <20111006.154117.730931075310414439.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-net: Prevent NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
	<1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 06 Oct 2011 12:41:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 28 Sep 2011 17:40:55 +0300

> This patch prevents a NULL dereference when the user has passed a length
> longer than an actual buffer to virtio-net.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Waiting for a respin of this patch with clarified comments.
