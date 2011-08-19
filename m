Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab1HSUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:47:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1HSUrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:47:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Subject: Re: [Bug #40282] IP forwarding regression since 3.0-rc6
Date: Fri, 19 Aug 2011 22:48:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera> <bkwpSnItbJM.A.r-H.mMCSOB@chimera> <20110819T132841.GA.a087a.stse@fsing.rootsland.net>
In-Reply-To: <20110819T132841.GA.a087a.stse@fsing.rootsland.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108192248.57430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Stephan Seitz wrote:
> On Sun, Aug 14, 2011 at 09:07:36PM +0200, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of regressions introduced between 2.6.39 and 3.0.
> >
> >The following bug entry is on the current list of known regressions
> >introduced between 2.6.39 and 3.0.  Please verify if it still should
> >be listed and let the tracking team know (either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40282
> >Subject		: IP forwarding regression since 3.0-rc6
> >Submitter	: Stephan Seitz <stse+lkml@fsing.rootsland.net>
> >Date		: 2011-07-25 12:51 (21 days old)
> >Message-ID	: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
> >References	: http://marc.info/?l=linux-kernel&m=131159880004908&w=2
> 
> It seems the bug has been completely fixed in kernel 3.0.3. At least 
> I don’t have any problems anymore. So I think the bug can be closed.

Thanks, closing.

Rafael
