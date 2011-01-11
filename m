Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1AKVNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:13:43 -0500
Received: from www84.your-server.de ([213.133.104.84]:54114 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab1AKVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:13:41 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        shemminger@vyatta.com, jj@chaosbits.net, daniel.baluta@gmail.com,
        jochen@jochen.org, hagen@jauu.net, torvalds@linux-foundation.org,
        pavel@ucw.cz
In-Reply-To: <20110111.125254.133402589.davem@davemloft.net>
References: <1294764515-15356-1-git-send-email-stefani@seibold.net>
	 <1294765273.2927.65.camel@edumazet-laptop>
	 <1294779020.16410.2.camel@wall-e>
	 <20110111.125254.133402589.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 11 Jan 2011 22:14:40 +0100
Message-ID: <1294780480.17388.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.01.2011, 12:52 -0800 schrieb David Miller:
> From: Stefani Seibold <stefani@seibold.net>
> Date: Tue, 11 Jan 2011 21:50:20 +0100
> 
> > Right, but currently there is no need for an IPV6 implementation, non of
> > our base station provide it and non of our mobile network customers use
> > it.
> > 
> > If it will be required in the future it will be implemented.
> 
> We require that you implement the ipv6 side for the submission right
> now.
> 
> Long gone are the days when we add ipv4 only implementations of
> protocols.

If nobody need it and no user in the near future out there, why should i
implement this? That is dogmatic only!

