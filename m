Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007Ab0GUB1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 21:27:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41040
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761771Ab0GUB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 21:27:38 -0400
Date: Tue, 20 Jul 2010 18:27:54 -0700 (PDT)
Message-Id: <20100720.182754.140729379.davem@davemloft.net>
To: joe@perches.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jdike@addtoit.com, mst@redhat.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279593240.19374.2.camel@Joe-Laptop.home>
References: <20100720122032.88e0fcd9.sfr@canb.auug.org.au>
	<1279593240.19374.2.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 19 Jul 2010 19:34:00 -0700

> On Tue, 2010-07-20 at 12:20 +1000, Stephen Rothwell wrote:
>> I fixed it up (see below) and can carry the fix as necessary.
> @@@ -527,15 -527,12 +527,14 @@@ static long vhost_net_set_backend(struc
>   
>         /* start polling new socket */
>         oldsock = vq->private_data;
> -       if (sock == oldsock)
> -               goto done;
> +       if (sock != oldsock){
> 
> Trivial: missing space before open brace in commit
> dd1f4078f0d2de74a308f00a2dffbd550cfba59f

Thanks guys, I'm taking care of this as I merge net-2.6 into
net-next-2.6
