Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1EYVMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:12:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1EYVMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:12:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex =?utf-8?q?Villac=C3=AD=C2=ADs_Lasso?= 
	<avillaci@fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Date: Wed, 25 May 2011 23:13:15 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera> <SFkDk2sBn_E.A.ScE.STwzNB@chimera> <4DDD20C3.4080603@fiec.espol.edu.ec>
In-Reply-To: <4DDD20C3.4080603@fiec.espol.edu.ec>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105252313.15643.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 25, 2011, Alex Villací­s Lasso wrote:
> El 14/05/11 17:40, Rafael J. Wysocki escribió:
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
> > Date		: 2011-02-07 17:21 (97 days old)
> >
> >
> >
> Still present in 2.6.39. Additionally there is a new regression in bug #35832.

Thanks for the update.

Rafael
