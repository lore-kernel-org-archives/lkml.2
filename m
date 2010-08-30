Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0H3Rl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:41:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0H3Rl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:41:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [Bug #17041] 2.6.36-rc1 hangs during XFS barrier test for /
Date: Mon, 30 Aug 2010 19:40:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera> <4AUWBNzTkbD.A.FI.7FueMB@chimera> <AANLkTikzDgHsPsUQMdb87R8dG61CBBekxBfhbuguLEPX@mail.gmail.com>
In-Reply-To: <AANLkTikzDgHsPsUQMdb87R8dG61CBBekxBfhbuguLEPX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301940.30362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Torsten Kaiser wrote:
> On Mon, Aug 30, 2010 at 12:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17041
> > Subject         : 2.6.36-rc1 hangs during XFS barrier test for /
> > Submitter       : Torsten Kaiser <just.for.lkml@googlemail.com>
> > Date            : 2010-08-20 (10 days old)
> > Message-ID      : <AANLkTim1PXibiY98GUdMj-UZLTav+n7GAnJ0Mjn6_5a3@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=128231691708710&w=2
> 
> As noted in comment #1 in this Bug, this was the same Bug as
> http://marc.info/?l=linux-kernel&m=128208298507451&w=2
> It is fixed as of 2.6.36-rc2.
> 
> You can close this Bug as fixed.

Thanks, closed.

Rafael
