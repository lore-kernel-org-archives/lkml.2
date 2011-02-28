Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1B1M6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:58:50 -0500
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:56082 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1B1M6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:58:48 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 07:58:48 EST
Date: Mon, 28 Feb 2011 13:51:23 +0100
From: "Michal 'vorner' Vaner" <vorner@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Michal Vaner <vorner@ucw.cz>
Subject: Re: [Bug #27402] Atheros adapter no longer loads firmware
Message-ID: <20110228125123.GA4810@dragonfly>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>, Michal Vaner <vorner@ucw.cz>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
 <f14qsMvj2tF.A.pHD.ScuYNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f14qsMvj2tF.A.pHD.ScuYNB@chimera>
Jabber-ID: vorner@ucw.cz
User-Agent: Mutt 1.5.21 (2010-09-15, Gentoo 1.5.21-r1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning

On Mon, Feb 21, 2011 at 11:37:10PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27402
> Subject		: Atheros adapter no longer loads firmware
> Submitter	: Michal Vaner <vorner@ucw.cz>
> Date		: 2011-01-23 15:29 (30 days old)
> First-Bad-Commit: http://git.kernel.org/linus/be93112accb42c5586a459683d71975cc70673ca

It seems it got fixed. I have no clue which of the two commits in the relevant
files could possibly fix it, but my adapter works now, with current git version
(493f3358cb289ccf716c5a14fa5bb52ab75943e5).

Thank you

With regard

PS: Sorry for taking so long for the reply, I was abroad last week.

-- 
The problem with graduate students, in general, is that they have
to sleep every few days.

Michal 'vorner' Vaner
