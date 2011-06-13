Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1FMRUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:20:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1FMRUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:20:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Bug #33842] NULL pointer dereference in ip_fragment
Date: Mon, 13 Jun 2011 19:21:39 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Tomas Carnecky <tom@dbservice.com>, David Miller <davem@davemloft.net>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera> <kTLfM29CaqB.A.K5F.f1S9NB@chimera> <1307915992.2872.170.camel@edumazet-laptop>
In-Reply-To: <1307915992.2872.170.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106131921.39276.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 12, 2011, Eric Dumazet wrote:
> Le dimanche 12 juin 2011 à 23:12 +0200, Rafael J. Wysocki a écrit :
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33842
> > Subject		: NULL pointer dereference in ip_fragment
> > Submitter	: Tomas Carnecky <tom@dbservice.com>
> > Date		: 2011-04-23 07:51 (51 days old)
> > 
> > 
> 
> This is probably fixed in current linux-2.6 tree, and 2.6.39.1 as well
> 
> 
> If not, maybe commit 64f3b9e203b (ip_expire() must revalidate route)
> needs to be included in 2.6.39.X
> 
> (I believe Greg took it for 2.6.38, but cant find it in 2.6.39 ?)

Thanks, closing.

Rafael
