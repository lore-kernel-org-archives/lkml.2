Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1AAVjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 16:39:14 -0500
Received: from www84.your-server.de ([213.133.104.84]:45414 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab1AAVjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 16:39:13 -0500
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293796458.2973.59.camel@edumazet-laptop>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	 <1293789629.2973.26.camel@edumazet-laptop>
	 <1293790979.4787.10.camel@wall-e>
	 <1293792066.2973.43.camel@edumazet-laptop>
	 <1293794589.5285.16.camel@wall-e>
	 <1293796458.2973.59.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 01 Jan 2011 22:40:16 +0100
Message-ID: <1293918016.28646.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 31.12.2010, 12:54 +0100 schrieb Eric Dumazet:
> Le vendredi 31 décembre 2010 à 12:23 +0100, Stefani Seibold a écrit :
> > Am Freitag, den 31.12.2010, 11:41 +0100 schrieb Eric Dumazet:
> > > Le vendredi 31 décembre 2010 à 11:22 +0100, Stefani Seibold a écrit :
> > > > Am Freitag, den 31.12.2010, 11:00 +0100 schrieb Eric Dumazet:
> > > > > Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
> > > > > écrit :
> > > > > > From: Stefani Seibold <stefani@seibold.net>
> > > > > > 

> > > This is not how things are dealed in linux, really.
> > > 
> > > You'll have to find a way so that things work well for everybody, not
> > > only for you.
> > > 
> > > I guess you must fix UDPCP protocol stack, not 'fix linux'
> > > 
> > 
> > I cannot fix it, because the information is still lost, and i need it. 
> > 
> 
> You can fix it. Really. If not, you can pay me and I'll fix it for you.
> 

I am a poor girl, so i did it by me self. Hope you like the new
approach.


