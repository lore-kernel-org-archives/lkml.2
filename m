Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1DQURR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:17:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1DQURK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:17:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #29852] 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
Date: Sun, 17 Apr 2011 22:17:29 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.lyF.a5uqNB@chimera> <BANLkTimGFqP7q845+zYnyjcO0PvoBGX_qg@mail.gmail.com>
In-Reply-To: <BANLkTimGFqP7q845+zYnyjcO0PvoBGX_qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172217.30033.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 17, 2011, Alexander Beregalov wrote:
> On 17 April 2011 17:52, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.37 and 2.6.38.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=29852
> > Subject         : 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
> > Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> > Date            : 2011-02-21 20:33 (56 days old)
> > Message-ID      : <AANLkTi=14N_c_B7mLY0H8Dt8pte6C0mjFnVuC37e44Hs@mail.gmail.com>
> > References      : http://marc.info/?l=linux-netdev&m=129832042402668&w=2
> >
> 
> Hi, Rafael.
> I do not see the problem since that time.
> Is it enough reason for closing it?

It is.  Please reopen if you see it again.

Thanks,
Rafael
