Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1ACKkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:40:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39648 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1ACKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d4cNYuOArqxEo1lTry3WvbFLO8Wvs+TBHYxE+YDLLTtEVHRQMOs/wazoiWYjjb1saE
         Ba0YApNodC0rcuD09tPSuMxjf6hno5pErSfx3yLg8V8tnTqfuvFAw8IRKZ8YtxuMcaH3
         SGn/pw9gpVeiB1iUclOxfCMToxNkUXL16Czcw=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, netdev@vger.kernel.org,
        shemminger@vyatta.com, daniel.baluta@gmail.com, jochen@jochen.org
In-Reply-To: <1294048469.20187.13.camel@wall-e>
References: <1294007971-18878-1-git-send-email-stefani@seibold.net>
	 <1294008562.2535.263.camel@edumazet-laptop>
	 <1294008917.18963.3.camel@wall-e>
	 <alpine.LNX.2.00.1101022356550.11481@swampdragon.chaosbits.net>
	 <1294045732.19666.6.camel@wall-e>
	 <1294046867.2892.101.camel@edumazet-laptop>
	 <1294048469.20187.13.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 11:39:59 +0100
Message-ID: <1294051199.2892.198.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 janvier 2011 à 10:54 +0100, Stefani Seibold a écrit :

> How can you do a routing, how can you determinate the MTU of the route.
> This are basics. Look into other code how this things will be handled is
> in my opinion the right way, since there a no function provide to do
> this.
> 

Hmm, how user land can perform this task then ?

Is there an open source implementation of UDPCP ?

What are its problems ? You say its dog slow, I really wonder why.
UDP stack is pretty scalable these days, yet some improvements are
possible.

Why not adding generic helpers if you believe you miss some
infrastructure ? This could benefit to other 'stacks' as well.

> Otherwise you can say the same about all the filesystem or PCI
> drvivers , which do also a lot in the same way. But since this is the
> way to do it, it is the right way.
> 

These drivers are here because of high performance on top of high
performance specs.

While UDPCP is only a layer above UDP. If the problem comes from UDP
being too slow, it'll be slow too.



