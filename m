Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1DAXsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:48:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1DAXso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:48:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex =?utf-8?q?Villac=C3=AD=C2=ADs_Lasso?= 
	<avillaci@fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Date: Sat, 2 Apr 2011 01:48:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera> <40UNry85rJN.A.CKF.Kp5jNB@chimera> <4D960E2F.1050408@fiec.espol.edu.ec>
In-Reply-To: <4D960E2F.1050408@fiec.espol.edu.ec>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104020148.42442.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 01, 2011, Alex Villací­s Lasso wrote:
> El 27/03/11 15:27, Rafael J. Wysocki escribió:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
> > Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
> > Submitter	: Alex Villacis Lasso<avillaci@ceibo.fiec.espol.edu.ec>
> > Date		: 2011-02-07 17:21 (49 days old)
> >
> >
> >
> Just checked yesterday. This bug is still present in 2.6.39-rc1.

Thanks for the update.

Rafael
