Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1AKVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:06:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44945 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab1AKVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wxirlM3PGrCKYZ/dJHFj3T89jsVBV/bIU68EWhX2NTTW6UiXhGLnw0syBCWx2OXRb3
         xN3sg0eYvUA46MyTys0CG3+BtRngbL7lSrVCsQ4hqdNVdevJDaxdw+EVqE8sjOIlM9/M
         +7eo5DEWzErqkp5j58bJBlcP/+YEwEkZ6gGHY=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com,
        jj@chaosbits.net, daniel.baluta@gmail.com, jochen@jochen.org,
        hagen@jauu.net, torvalds@linux-foundation.org, pavel@ucw.cz
In-Reply-To: <1294779020.16410.2.camel@wall-e>
References: <1294764515-15356-1-git-send-email-stefani@seibold.net>
	 <1294765273.2927.65.camel@edumazet-laptop>
	 <1294779020.16410.2.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 22:06:17 +0100
Message-ID: <1294779977.3447.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 janvier 2011 à 21:50 +0100, Stefani Seibold a écrit :
> Am Dienstag, den 11.01.2011, 18:01 +0100 schrieb Eric Dumazet:
> > Le mardi 11 janvier 2011 à 17:48 +0100, stefani@seibold.net a écrit :
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > ...
> > > The implementation is clean and has absolut no side effects to the network
> > > subsystems so i ask for merge it into linux, mm-tree or linux-next.
> > > 
> > > The patch is against the current linux git tree
> > > 
> > > - Stefani
> > > 
> > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > > ---
> > >  
> > 
> > Reading again UDPCP specs, I find it is IPv4/IPv6 agnostic
> > 
> > You copied IPv4 UDP code, so this only handles IPv4...
> > 
> 
> Right, but currently there is no need for an IPV6 implementation, non of
> our base station provide it and non of our mobile network customers use
> it.
> 
> If it will be required in the future it will be implemented.
> 
> 

All I wanted to point out is the implementation you did, using a copy of
code instead of stacked layer, makes this ipv6 a whole rewrite.

Better understand know the implications, before code inclusion.

I understand your code satisfies your immediate needs (and companies
that paid this development), but we should make a step forward in code
reuse.



