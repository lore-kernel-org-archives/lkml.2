Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1BTKrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 05:47:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39910 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab1BTKrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 05:47:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Mesmon <jmesmon@gmail.com>
Subject: Re: [Bug #27762] Brightness Adjustment on Toshiba nb305 Netbooks is non-functional.
Date: Sun, 20 Feb 2011 11:47:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <8H3lez1sawF.A.vtH.IBxVNB@chimera> <AANLkTinfAVyRupWqA7fJFO3TZe8X8w5UVtiFxzFTPYj5@mail.gmail.com>
In-Reply-To: <AANLkTinfAVyRupWqA7fJFO3TZe8X8w5UVtiFxzFTPYj5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102201147.09105.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 20, 2011, John Mesmon wrote:
> Not sure when this was fixed, but
> a5bbef0b2deb7b943f095181309ecc9e1fc91c0f works.

Thanks, closing.

Rafael


> On Sat, Feb 12, 2011 at 6:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=27762
> > Subject         : Brightness Adjustment on Toshiba nb305 Netbooks is non-functional.
> > Submitter       : John Mesmon <jmesmon@gmail.com>
> > Date            : 2011-01-29 03:47 (15 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/44834a67c0082e2cf74b16be91e49108b1432d65
