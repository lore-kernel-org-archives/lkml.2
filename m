Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0KSUhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:37:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab0KSUhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:37:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions from 2.6.36
Date: Fri, 19 Nov 2010 21:37:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera> <AANLkTimBJAKUEe3POB49DFSxqZzQAd03e_3Rn-0mP4wY@mail.gmail.com>
In-Reply-To: <AANLkTimBJAKUEe3POB49DFSxqZzQAd03e_3Rn-0mP4wY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011192137.02426.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Alex Deucher wrote:
> On Thu, Nov 18, 2010 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message contains a list of some regressions from 2.6.36,
> > for which there are no fixes in the mainline known to the tracking team.
> > If any of them have been fixed already, please let us know.
> >
> > If you know of any other unresolved regressions from 2.6.36, please let us
> > know either and we'll add them to the list.  Also, please let us know
> > if any of the entries below are invalid.
> >
> > Each entry from the list will be sent additionally in an automatic reply
> > to this message with CCs to the people involved in reporting and handling
> > the issue.
> >
> >
> > Listed regressions statistics:
> >
> >  Date          Total  Pending  Unresolved
> >  ----------------------------------------
> >  2010-11-19       39       29          25
> >
> >
> > Unresolved regressions
> > ----------------------
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=23222
> > Subject         : 2.6.36 radeon KMS: [drm] Cannot find any crtc or sizes
> > Submitter       : Ján Bednár <jan.bednar@gmail.com>
> > Date            : 2010-11-18 15:33 (1 days old)
> >
> 
> I've added a fix to that bug.

It doesn't seem to have helped, though.

Thanks,
Rafael
