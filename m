Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab1F2T16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:27:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab1F2T15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:27:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexander Zhaunerchyk <alex.vizor@gmail.com>
Subject: Re: [Bug #36452] Artifacts with 3.0-rc1 on SandyBridge
Date: Wed, 29 Jun 2011 21:28:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <20110629094717.10df4637@jbarnes-desktop> <4E0B5A8F.4020905@gmail.com>
In-Reply-To: <4E0B5A8F.4020905@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292128.55700.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 29, 2011, Alexander Zhaunerchyk wrote:
> This was with integrated graphics. But seems this is fixed in rc5 or 
> rc5+ because after compiling rc5 I  didn't see these artifacts anymore

OK, I'm closing the bug then.

Thanks,
Rafael


> On 29.06.2011 19:47, Jesse Barnes wrote:
> > On Sun, 26 Jun 2011 23:23:44 +0200 (CEST)
> > "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
> >
> >> This message has been generated automatically as a part of a summary report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> >> know (either way).
> >>
> >>
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36452
> >> Subject		: Artifacts with 3.0-rc1 on SandyBridge
> >> Submitter	: Alex Zhavnerchik<alex.vizor@gmail.com>
> >> Date		: 2011-06-01 13:55 (26 days old)
> > Is this with integrated or discrete graphics?  Have you tried to bisect
> > yet?
> >
> 
> 

