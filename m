Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0LSNkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 08:40:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab0LSNko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 08:40:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Subject: Re: [Bug #21662] 2.6.35->2.6.36 regression, vanilla kernel panic, ppp or hrtimers crashing
Date: Sun, 19 Dec 2010 14:39:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera> <xqq2Z3iR9HJ.A.WhG.q1fDNB@chimera> <201012191514.10820.nuclearcat@nuclearcat.com>
In-Reply-To: <201012191514.10820.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012191439.42365.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 19, 2010, Denys Fedoryshchenko wrote:
> On Sunday 19 December 2010 14:50:26 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21662
> > Subject		: 2.6.35->2.6.36 regression, vanilla kernel panic, ppp or 
> hrtimers
> > crashing Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
> > Date		: 2010-10-25 9:22 (56 days old)
> > Message-ID	: <201010251222.37191.nuclearcat@nuclearcat.com>
> > References	: http://marc.info/?l=linux-kernel&m=128799855826011&w=2
> It is fixed, i guess for 2.6.37, patch works for me.
> 
> http://marc.info/?l=linux-netdev&m=129219516718477&w=2
> Andrej Ota (1):
>       pppoe.c: Fix kernel panic caused by __pppoe_xmit

Thanks, closing.

Rafael
