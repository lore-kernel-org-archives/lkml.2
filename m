Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1ABWPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 17:15:54 -0500
Received: from www84.your-server.de ([213.133.104.84]:54174 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1ABWPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 17:15:53 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1294005329.2535.258.camel@edumazet-laptop>
References: <1293982286-15389-1-git-send-email-stefani@seibold.net>
	 <1294005329.2535.258.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 02 Jan 2011 23:16:56 +0100
Message-ID: <1294006616.5675.13.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 02.01.2011, 22:55 +0100 schrieb Eric Dumazet:
> Le dimanche 02 janvier 2011 à 16:31 +0100, stefani@seibold.net a écrit :
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > Changelog:
> > 31.12.2010 first proposal
> > 01.01.2011 code cleanup and fixes suggest by Eric Dumazet
> > 02.01.2011 kick away UDP-Lite support
> >            change spin_lock_irq into spin_lock_bh
> > 	   faster udpcp_release_sock
> > 	   base is now linux-next
> 
> Since you depend on zlib_adler32(), you should add a dependence in
> Kconfig so that its available
> 
> select ZLIB_INFLATE
> 

No this is not necessary, since zlib_adler32() is defined as a static
inline function in include/linux/zutil.h


