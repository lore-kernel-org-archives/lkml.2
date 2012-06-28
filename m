Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2F1Xza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:55:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2F1Xz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:55:26 -0400
Date: Thu, 28 Jun 2012 16:55:25 -0700 (PDT)
Message-Id: <20120628.165525.131827870929792389.davem@davemloft.net>
To: vlee@twitter.com
Cc: edumazet@google.com, mirq-linux@rere.qmqm.pl, jpirko@redhat.com,
        therbert@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tdmackey@twitter.com
Subject: Re: [PATCH] net: Downgrade CAP_SYS_MODULE deprecated message from
 error to warning.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340843527-9962-1-git-send-email-vlee@twitter.com>
References: <1340843527-9962-1-git-send-email-vlee@twitter.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinson Lee <vlee@twitter.com>
Date: Wed, 27 Jun 2012 17:32:07 -0700

> Make logging level consistent with other deprecation messages in net
> subsystem.
> 
> Signed-off-by: Vinson Lee <vlee@twitter.com>
> Cc: David Mackey <tdmackey@twitter.com>

Applied, thanks.
