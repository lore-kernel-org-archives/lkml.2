Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1FVGmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:42:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1FVGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:42:49 -0400
Date: Tue, 21 Jun 2011 23:42:11 -0700 (PDT)
Message-Id: <20110621.234211.421102945649677953.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] notifiers: split notifier.h into subsystem headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1308724522-32461-1-git-send-email-amwang@redhat.com>
References: <1308724522-32461-1-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Jun 2011 23:42:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Wed, 22 Jun 2011 14:35:17 +0800

> Now we define all kinds of notifiers in notifier.h, this is not
> necessary at all, since different subsystems use different
> notifiers, they are almost non-related with each other.
> 
> This can also save much build time. Suppose I add a new netdevice
> event, really I don't have to recompile all the source, just network
> related. Without this patch, all the source will be recompiled.
> 
> I move the notify events near to their subsystem notifier registers,
> so that they can be found more easily.
> 
> In case of conflicts, I hope Andrew Morton would take the whole
> patchset, rather than different subsystem maintainers take their own.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
