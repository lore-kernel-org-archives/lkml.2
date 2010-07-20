Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0GTCeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 22:34:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1962 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab0GTCeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 22:34:04 -0400
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>, "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <20100720122032.88e0fcd9.sfr@canb.auug.org.au>
References: <20100720122032.88e0fcd9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 19:34:00 -0700
Message-ID: <1279593240.19374.2.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 12:20 +1000, Stephen Rothwell wrote:
> I fixed it up (see below) and can carry the fix as necessary.
@@@ -527,15 -527,12 +527,14 @@@ static long vhost_net_set_backend(struc
  
        /* start polling new socket */
        oldsock = vq->private_data;
-       if (sock == oldsock)
-               goto done;
+       if (sock != oldsock){

Trivial: missing space before open brace in commit
dd1f4078f0d2de74a308f00a2dffbd550cfba59f


