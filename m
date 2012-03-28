Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2C1Osl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:48:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63041 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2C1Osj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:48:39 -0400
Subject: Re: [PATCH] tcp: bind() use stronger condition for bind_conflict
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Flavio Leitner <fbl@redhat.com>
Cc: Alexandru Copot <alex.mihai.c@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Baluta <dbaluta@ixiacom.com>
In-Reply-To: <20120328105212.1cb8dfe5@asterix.rh>
References: <1332882712-10756-1-git-send-email-alex.mihai.c@gmail.com>
	 <20120328105212.1cb8dfe5@asterix.rh>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Mar 2012 16:48:33 +0200
Message-ID: <1332946113.2325.9.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 10:52 -0300, Flavio Leitner wrote:
> On Wed, 28 Mar 2012 00:11:52 +0300
> Alexandru Copot <alex.mihai.c@gmail.com> wrote:
> 

> > diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
> > index 02dd203..dfc8bc3 100644
> > --- a/net/ipv6/inet6_connection_sock.c
> > +++ b/net/ipv6/inet6_connection_sock.c
> > @@ -28,7 +28,8 @@
> >  #include <net/inet6_connection_sock.h>
> >  
> >  int inet6_csk_bind_conflict(const struct sock *sk,
> > -			    const struct inet_bind_bucket *tb)
> > +			    const struct inet_bind_bucket *tb,
> > +				int relax)
> 
> Same here
> Maybe you can wait for more feedbacks before spin another patch 
> version just to fix that.
> 



Also 'int relax' should be 'bool relax'... 1/0 -> true/false

Anyway net-next is not open yet...


