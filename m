Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1CQWrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:47:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43194 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1CQWrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:47:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex =?utf-8?q?Villac=C3=AD=C2=ADs_Lasso?= 
	<avillaci@fiec.espol.edu.ec>
Subject: Re: [Bug #28522] Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Date: Thu, 17 Mar 2011 23:47:12 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
References: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera> <GTlFTeOGjrB.A.hEF.Or3cNB@chimera> <4D822129.1030000@fiec.espol.edu.ec>
In-Reply-To: <4D822129.1030000@fiec.espol.edu.ec>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103172347.12346.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 17, 2011, Alex Villací­s Lasso wrote:
> El 06/03/11 07:10, Rafael J. Wysocki escribió:
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
> > Date		: 2011-02-07 17:21 (28 days old)
> >
> >
> >
> Still present in 2.6.38 .

Thanks for the update.

Rafael
