Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1ABL4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 06:56:54 -0500
Received: from www84.your-server.de ([213.133.104.84]:37762 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1ABL4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 06:56:53 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1293967996.2535.76.camel@edumazet-laptop>
References: <1293918276-28773-1-git-send-email-stefani@seibold.net>
	 <1293920601.2535.64.camel@edumazet-laptop>
	 <1293967023.29525.16.camel@wall-e>
	 <1293967996.2535.76.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 02 Jan 2011 12:57:56 +0100
Message-ID: <1293969476.29869.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 02.01.2011, 12:33 +0100 schrieb Eric Dumazet:
> Le dimanche 02 janvier 2011 à 12:17 +0100, Stefani Seibold a écrit :
> > Am Samstag, den 01.01.2011, 23:23 +0100 schrieb Eric Dumazet:
> 
> > > 3) I see UDPLITE references in your code. Are you sure UDPCP protocol
> > > can really work on top of UDPLITE ? I think not, so please remove dead
> > > code.
> > > 
> > 
> > I have not tested it yet. But i think i should work, the code is mostly
> > stolen from the udp.c file. Since the stack not depend on the len field
> > of the UDP header, it should not matter if UPD or UDP-Lite is used.
> > 
> 
> Hmm, but isnt your :
> 
> udpcp_prot = udp_prot; /* in udpcp_init() */
> 
> implies that all UDPCP sockets you are going to provide to user are on
> top of UDP, not UDPLITE ?
> 

Okay, i kick to udplite support away!

> Also, could you provide a link to UDPCP protocol specs ?
> 

http://read.pudn.com/downloads76/doc/project/283718/OBSAI/OBSAI/RP1_V2.0.PDF

> Thanks
> 
> 


