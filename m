Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab2BHI4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 03:56:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750706Ab2BHI43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 03:56:29 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19+rtcUFph+uruz0B/H0nV4OnhUex6U4cI2btu5NR
	/jLQvYs/CBTIT/
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Subject: Re: swap storm since kernel 3.2.x
Date: Wed, 8 Feb 2012 09:56:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.20; KDE/4.8.0; i686; ; )
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org
References: <201202041109.53003.toralf.foerster@gmx.de> <201202051107.26634.toralf.foerster@gmx.de> <CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com>
In-Reply-To: <CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202080956.18727.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hillf Danton wrote at 12:38:31
> 2012/2/5 Toralf Förster <toralf.foerster@gmx.de>:
> > Hillf Danton wrote at 05:45:40
> > 
> >> Would you please try the patchset of Rik?
> >> 
> >>          https://lkml.org/lkml/2012/1/26/374
> > 
> > It doesn't applied successfully agains 3.2.3 (+patch +f 3.2.5)
> > 
> > :-(
> 
> That patchset already in -next tree, mind to try it with
> CONFIG_SLUB_DEBUG first disabled, and try again with it enabled?
> 
> Hillf
I switched back to 3.0.20 in the mean while.

>From what I can tell is this:
If the system is under heavy I/O load and hasn't too much free RAM (git pull, 
svn update and RAM consuming BOINC applications) then kernel 3.0.20 handle 
this somehow while 3.2.x run into a swap storm like.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
