Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab1EBSlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:41:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab1EBSk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:40:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex =?utf-8?q?Villac=C3=AD=C2=ADs_Lasso?= 
	<avillaci@fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Date: Mon, 2 May 2011 20:41:03 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
References: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera> <9nxEC7x0HFO.A.VFH.O0GvNB@chimera> <4DBEDC84.5010903@fiec.espol.edu.ec>
In-Reply-To: <4DBEDC84.5010903@fiec.espol.edu.ec>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105022041.04163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 02, 2011, Alex Villací­s Lasso wrote:
> El 30/04/11 15:17, Rafael J. Wysocki escribió:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.37 and 2.6.38.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
> > Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
> > Submitter	: Alex Villacis Lasso<avillaci@ceibo.fiec.espol.edu.ec>
> > Date		: 2011-02-07 17:21 (83 days old)
> >
> >
> >
> Still present witn 2.6.39-rc5.

Thanks for the update.

Rafael
