Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1AEWkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:40:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35286 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1AEWkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:40:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58 uploaded]
Date: Wed, 5 Jan 2011 23:39:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, steiner@sgi.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <201101042357.08600.rjw@sisk.pl> <4D24E444.6080308@gmail.com>
In-Reply-To: <4D24E444.6080308@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101052339.46453.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 05, 2011, Jiri Slaby wrote:
> On 01/04/2011 11:57 PM, Rafael J. Wysocki wrote:
> > On Tuesday, January 04, 2011, Jiri Slaby wrote:
> >> On 01/04/2011 02:40 PM, Jiri Slaby wrote:
> >>> On 12/24/2010 01:58 AM, akpm@linux-foundation.org wrote:
> >>>> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
> >>>
> >>> Hi, this kernel regresses with respect to suspend to ram in comparison
> >>> with mmotm 2010-12-16-14-56.
> >>>
> >>> This is OK:
> >>> echo devices > /sys/power/pm_test
> >>> pm-suspend
> >>> This hangs at suspend phase:
> >>> echo platform > /sys/power/pm_test
> >>> pm-suspend
> > 
> > Hmm.  So it looks like _PTS hangs?
> 
> No _PST here :).

I really meant _PTS and yes, there is one and it does quite a lot of
interesting stuff.

Are you able to collect serial console (or equivalent) logs from that machine?

Rafael


