Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1ABWbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 17:31:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40159 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ABWbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 17:31:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WyIbmmGkccO/9rjyatnG1libmYPkDC8kP7D1vd9Ef8rVCvJWU5q1rw+ptIVeDCIMEd
         tNX2YG2W8tg7A/brwLB7Dj4xcr4giPPvFNPpJqkmQRquxeVRhkIWvWiGx9Pe+GMpeWIa
         +FQa+YkZEAn7bSfSa5AXH8+PRh14g7X9p2Sg4=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1294006616.5675.13.camel@wall-e>
References: <1293982286-15389-1-git-send-email-stefani@seibold.net>
	 <1294005329.2535.258.camel@edumazet-laptop>
	 <1294006616.5675.13.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 23:31:26 +0100
Message-ID: <1294007486.2535.259.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 janvier 2011 à 23:16 +0100, Stefani Seibold a écrit :
> Am Sonntag, den 02.01.2011, 22:55 +0100 schrieb Eric Dumazet:
> > Le dimanche 02 janvier 2011 à 16:31 +0100, stefani@seibold.net a écrit :
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > Changelog:
> > > 31.12.2010 first proposal
> > > 01.01.2011 code cleanup and fixes suggest by Eric Dumazet
> > > 02.01.2011 kick away UDP-Lite support
> > >            change spin_lock_irq into spin_lock_bh
> > > 	   faster udpcp_release_sock
> > > 	   base is now linux-next
> > 
> > Since you depend on zlib_adler32(), you should add a dependence in
> > Kconfig so that its available
> > 
> > select ZLIB_INFLATE
> > 
> 
> No this is not necessary, since zlib_adler32() is defined as a static
> inline function in include/linux/zutil.h
> 
> 

Wow, this huge function is inlined, how shocking :)



