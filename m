Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1AKUtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:49:41 -0500
Received: from www84.your-server.de ([213.133.104.84]:57901 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1AKUtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:49:39 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com,
        jj@chaosbits.net, daniel.baluta@gmail.com, jochen@jochen.org,
        hagen@jauu.net, torvalds@linux-foundation.org, pavel@ucw.cz
In-Reply-To: <1294765273.2927.65.camel@edumazet-laptop>
References: <1294764515-15356-1-git-send-email-stefani@seibold.net>
	 <1294765273.2927.65.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 11 Jan 2011 21:50:20 +0100
Message-ID: <1294779020.16410.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.01.2011, 18:01 +0100 schrieb Eric Dumazet:
> Le mardi 11 janvier 2011 à 17:48 +0100, stefani@seibold.net a écrit :
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> ...
> > The implementation is clean and has absolut no side effects to the network
> > subsystems so i ask for merge it into linux, mm-tree or linux-next.
> > 
> > The patch is against the current linux git tree
> > 
> > - Stefani
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  
> 
> Reading again UDPCP specs, I find it is IPv4/IPv6 agnostic
> 
> You copied IPv4 UDP code, so this only handles IPv4...
> 

Right, but currently there is no need for an IPV6 implementation, non of
our base station provide it and non of our mobile network customers use
it.

If it will be required in the future it will be implemented.


