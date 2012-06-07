Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab2FGMw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:52:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43791 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab2FGMw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:52:26 -0400
Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jcliburn@gmail.com, chris.snook@gmail.com,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
In-Reply-To: <1339072653.3018.9.camel@localhost.localdomain>
References: <1329063403.1449.14.camel@localhost.localdomain>
	 <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com>
	 <1329204997.24837.15.camel@edumazet-laptop>
	 <1329366846.5646.1.camel@edumazet-laptop>
	 <1329847015.5133.4.camel@localhost.localdomain>
	 <1329848093.18384.35.camel@edumazet-laptop>
	 <1330111229.15610.50.camel@edumazet-laptop>
	 <1330163565.1419.5.camel@localhost.localdomain>
	 <20120606003856.GA7839@burratino>
	 <1339072653.3018.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 14:52:17 +0200
Message-ID: <1339073537.5083.4.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 14:37 +0200, Thomas Meyer wrote:
> Am Dienstag, den 05.06.2012, 19:38 -0500 schrieb Jonathan Nieder:
> > In February, 2012, Thomas Meyer wrote:
> > > Am Freitag, den 24.02.2012, 20:20 +0100 schrieb Eric Dumazet:
> > 
> > >> Here is a cumulative patch to hopefuly remove the races in this driver,
> > >> could you please test it ?
> > [...]
> > > just building a 3.2.7 kernel with your patch applied. I will watch out
> > > for the warning in the next days.
> > 
> > Well, did it work? :)
> 
> Hi Jonathan,
> 
> no it didn't. I still get these warnings.

I sent another patch today, you might try it ;)

https://lkml.org/lkml/2012/6/7/143



