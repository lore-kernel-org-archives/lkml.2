Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2BBT1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:27:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44796 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2BBT1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:27:35 -0500
Date: Thu, 02 Feb 2012 14:27:29 -0500 (EST)
Message-Id: <20120202.142729.317148369355280290.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        glommer@parallels.com, mst@redhat.com
Subject: Re: [v3.3-rc2+ PATCH] tcp: properly initialize tcp memory limits
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120202100700.38694.80000.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120202100700.38694.80000.stgit@amd-6168-8-1.englab.nay.redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Feb 2012 11:27:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 02 Feb 2012 18:07:00 +0800

> Commit 4acb4190 tries to fix the using uninitialized value
> introduced by commit 3dc43e3,  but it would make the
> per-socket memory limits too small.
> 
> This patch fixes this and also remove the redundant codes
> introduced in 4acb4190.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
