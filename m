Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1FQD0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:26:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50625 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1FQD0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:26:11 -0400
Date: Thu, 16 Jun 2011 23:23:44 -0400 (EDT)
Message-Id: <20110616.232344.2285390268187937319.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, kaber@trash.net, sage@newdream.net,
        samuel@sortiz.org, paul.moore@hp.com, vladislav.yasevich@hp.com,
        sri@us.ibm.com, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: Remove casts of void *
From: David Miller <davem@davemloft.net>
In-Reply-To: <d010144f11f9165670ac0c9e3559bf5e3191ff28.1308017857.git.joe@perches.com>
References: <cover.1308017857.git.joe@perches.com>
	<d010144f11f9165670ac0c9e3559bf5e3191ff28.1308017857.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Jun 2011 20:23:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 13 Jun 2011 19:21:26 -0700

> Unnecessary casts of void * clutter the code.
> 
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.
> 
> Done via coccinelle script:
> 
> $ cat cast_void_pointer.cocci
> @@
> type T;
> T *pt;
> void *pv;
> @@
> 
> - pt = (T *)pv;
> + pt = pv;
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
