Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0IFSjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:39:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0IFSjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:39:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Date: Mon, 6 Sep 2010 20:37:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org> <20100906071759.GB2356@schottelius.org> <AANLkTimhofj_=bij5QhY0jg9GDuH9_+axviY2DHq_6U1@mail.gmail.com>
In-Reply-To: <AANLkTimhofj_=bij5QhY0jg9GDuH9_+axviY2DHq_6U1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009062037.55898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 06, 2010, Jeff Chua wrote:
> On Mon, Sep 6, 2010 at 3:17 PM, Nico Schottelius
> <nico-linux-20100709@schottelius.org> wrote:
> > after some time away from the kernel sources, here my latest report
> > using Linux on the X201:
> >
> >  vmlinuz-2.6.36-rc1-00051-g3b89f56
> >  vmlinuz-2.6.36-rc2-00237-gd4348c6
> >  vmlinuz-2.6.36-rc3
> >
> > all come up with a black screen at resume.
> 
> Same problem here. X201s. Haven't had time to bisect.

Somebody has already done that:

http://marc.info/?l=linux-kernel&m=128376394825563&w=4

Thanks,
Rafael
