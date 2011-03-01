Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1CAIkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:40:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49793 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755696Ab1CAIkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:40:19 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/9Bw9tj4H9mxFmYchDrzgxKkA9QAnDqBo3Ul3jeI
	M3W9xeCEEptgtR
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: ThinkPad T400 : should kernel option "reboot=pci" be hard coded ?
Date: Tue, 1 Mar 2011 09:40:13 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.2; KDE/4.4.5; i686; ; )
References: <201006071122.21925.toralf.foerster@gmx.de> <201006091343.48924.toralf.foerster@gmx.de> <AANLkTimkWN5tU88J-M3Q4aq9pq-WljyyPAUPfnf9cuhf@mail.gmail.com>
In-Reply-To: <AANLkTimkWN5tU88J-M3Q4aq9pq-WljyyPAUPfnf9cuhf@mail.gmail.com>
Cc: Pedro Ribeiro <pedrib@gmail.com>, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103010940.13647.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pedro Ribeiro wrote at 07:01:28
> > Matthew Garrett wrote at 16:11:03
> > 
> >> No, the best thing to do would be to figure out what changed to require
> >> the extra 9 seconds. Are you able to work out which the last kernel
> >> release without this timeout was?
> > 

> I also have a T400, and reboot=pci solves the problem for me.
> 
> Just tested with kernel 2.6.20 and the 9 second boot delay is still
> there. Maybe this should be hardcoded...

I'd like to point to this after a half year of lthe last email. Shouldn't it 
be hard coded ?


-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

