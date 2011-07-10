Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1GJUUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:20:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1GJUUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:20:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olaf Freyer <aaron667@gmx.net>
Subject: Re: [Bug #36182] Erroneous package power limit notification since kernel 2.6.39
Date: Sun, 10 Jul 2011 22:20:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.Sh.gmYGOB@chimera> <4E19DB69.5020406@gmx.net>
In-Reply-To: <4E19DB69.5020406@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107102220.58278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 10, 2011, Olaf Freyer wrote:
> This issue is still worth listing, as it isn't resolved yet.
> 
> Jesse Barnes already tracked down the cause to commit
> ccab5c82759e2ace74b2e84f82d1e0eedd932571 -
> but what to do now remains unclear to me.
> 
> With the patch reverted, I get down to 1 warning per workday -
> without reverting it I'm at 70-90k warnings per workday.

Thanks for the update.

Rafael


> Am 10.07.2011 12:58, schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36182
> > Subject		: Erroneous package power limit notification since kernel 2.6.39
> > Submitter	: Olaf Freyer <aaron667@gmx.net>
> > Date		: 2011-05-22 13:01 (50 days old)
> > Message-ID	: <4DD9092A.4080507@gmx.net>
> > References	: http://marc.info/?l=linux-kernel&m=130606930631131&w=2
> >
> >
> >
> 
> 
> 

