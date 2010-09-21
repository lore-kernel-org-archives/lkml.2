Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0IUSJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:09:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50388 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755668Ab0IUSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:09:44 -0400
X-Sasl-enc: eRC4s0hx5+L8l75vOMZCaMMfctImDx0BQK72brnw+DVU 1285092583
Date: Tue, 21 Sep 2010 15:09:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jarek Poplawski <jarkao2@gmail.com>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3] ip: fix truesize mismatch in ip fragmentation
Message-ID: <20100921180940.GA8754@khazad-dum.debian.net>
References: <20100920174443.GA5515@elliptictech.com>
 <1285006844.2323.17.camel@edumazet-laptop>
 <20100920195256.GA14330@elliptictech.com>
 <1285013853.2323.148.camel@edumazet-laptop>
 <1285018272.2323.243.camel@edumazet-laptop>
 <20100921140501.GA21572@elliptictech.com>
 <1285078613.2617.503.camel@edumazet-laptop>
 <1285084705.2617.636.camel@edumazet-laptop>
 <20100921162657.GA22183@khazad-dum.debian.net>
 <1285086679.2617.672.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285086679.2617.672.camel@edumazet-laptop>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Eric Dumazet wrote:
> Le mardi 21 septembre 2010 à 13:26 -0300, Henrique de Moraes Holschuh a
> écrit :
> > Should this be a candidate for -stable?
> > 
> 
> Yes, of course, but David wants to handle stable submissions himself.
> 
> I am not sure we want to bug stable team with dozens of mails while
> polishing patches ?

We don't.  But one often marks commits that should go to -stable using a Cc:
pseudo-header, and also includes relevant information (e.g. to which stable
kernels it should be applied to) to the commit message.

Since there wasn't one, and I didn't readly find any post in this thread
that mentioned it should also go to stable, AND it looked at first glance
like something that should go to stable, I asked about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
