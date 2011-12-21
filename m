Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1LUSAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:00:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52983 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1LUSAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:00:05 -0500
Message-ID: <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 21 Dec 2011 19:00:01 +0100
In-Reply-To: <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4EF200BB.7000209@bootc.net>
	 <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF2117F.6000803@bootc.net>
	 <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 décembre 2011 à 18:36 +0100, Eric Dumazet a écrit :

> Good point, thats a different problem then, since 3.1 is not supposed to
> have this bug.
> 
> It seems rt->rt6i_peer points to invalid memory in your crash.
> 
> (RBX=00000000000001f4)
> 
> 8b 83 a4 00 00 00       mov    0xa4(%rbx),%eax    p->refcnt
> 1f4+a4 -> CR2=0000000000000298
> 

It would help if you can confirm latest linux tree can reproduce the
bug.

Thanks !


