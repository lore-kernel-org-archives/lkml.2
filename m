Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab1FQTXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:23:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49299 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445Ab1FQTXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:23:02 -0400
Date: Fri, 17 Jun 2011 15:19:03 -0400 (EDT)
Message-Id: <20110617.151903.1203335395245647912.davem@davemloft.net>
To: joe@perches.com
Cc: acme@ghostprotocols.net, jcliburn@gmail.com, chris.snook@gmail.com,
        jie.yang@atheros.com, sathya.perla@emulex.com,
        subbu.seetharaman@emulex.com, ajit.khaparde@emulex.com,
        rmody@brocade.com, ddutt@brocade.com, sjur.brandeland@stericsson.com,
        divy@chelsio.com, leitao@linux.vnet.ibm.com, amit.salecha@qlogic.com,
        ron.mercer@qlogic.com, linux-driver@qlogic.com,
        anirban.chakraborty@qlogic.com, jdmason@kudzu.us,
        linux-net-drivers@solarflare.com, shodgson@solarflare.com,
        bhutchings@solarflare.com, venza@brownhat.org, dave@thedillows.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2] drivers/net: Remove casts of void *
From: David Miller <davem@davemloft.net>
In-Reply-To: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
References: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Jun 2011 12:19:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 16 Jun 2011 22:08:06 -0700

> Unnecessary casts of void * clutter the code.
> 
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.
> 
> Done via coccinelle script (and a little editing):
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
> Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> Acked-By: Chris Snook <chris.snook@gmail.com>
> Acked-by: Jon Mason <jdmason@kudzu.us>

Applied, thanks.
