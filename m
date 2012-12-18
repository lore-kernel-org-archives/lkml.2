Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2LREtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:49:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55009 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LREtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:49:23 -0500
Date: Mon, 17 Dec 2012 20:49:19 -0800 (PST)
Message-Id: <20121217.204919.1174594015682114662.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH] tuntap: fix sparse warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355799627-55529-1-git-send-email-jasowang@redhat.com>
References: <1355799627-55529-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 18 Dec 2012 11:00:27 +0800

> Make tun_enable_queue() static to fix the sparse warning:
> 
> drivers/net/tun.c:399:19: sparse: symbol 'tun_enable_queue' was not declared. Should it be static?
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
