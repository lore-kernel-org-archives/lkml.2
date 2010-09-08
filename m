Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0IHKRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:17:52 -0400
Received: from www.tglx.de ([62.245.132.106]:42067 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0IHKRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:17:51 -0400
Date: Wed, 8 Sep 2010 12:17:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org
Subject: Re: slow nanosleep?
In-Reply-To: <1283940863.2880.37.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.00.1009081217100.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>  <1283932600.2880.1.camel@edumazet-laptop>  <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>  <1283934289.2880.12.camel@edumazet-laptop> 
 <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>  <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6> <1283940863.2880.37.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1657355147-1283941043=:2477"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1657355147-1283941043=:2477
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 8 Sep 2010, Eric Dumazet wrote:

> Le mercredi 08 septembre 2010 à 11:51 +0200, Thomas Gleixner a écrit :
> > +       if (!tu.tv_sec && !tu.tv_usec)
> > +               return 0;
> > + 
> 
> You need tu.tv_nsec here ;)

Details :)
---1463795968-1657355147-1283941043=:2477--
