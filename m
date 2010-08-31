Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0HaUVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:21:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab0HaUVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:21:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bug #16771] [Bisected Regression in 2.6.35] A full tmpfs filesystemcauses hibernationto hang
Date: Tue, 31 Aug 2010 22:19:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.oHB.0bueMB@chimera> <4C7D146E.8020601@superonline.com>
In-Reply-To: <4C7D146E.8020601@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008312219.39694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 31, 2010, M. Vefa Bicakci wrote:
> On 30/08/10 02:13 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16771
> > Subject		: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
> > Submitter	: M. Vefa Bicakci <bicave@superonline.com>
> > Date		: 2010-08-15 5:25 (15 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> > Message-ID	: <4C677A49.4030904@superonline.com>
> > References	: http://marc.info/?l=linux-kernel&m=128184995401968&w=2
> > 
> 
> Dear Rafael Wysocki,
> 
> This regression still exists in 2.6.35.4. (I haven't tested 2.6.36-rcX
> series.) Kosaki Motohiro has kindly helped me with this issue and found
> a fix for the regression. Today I have successfully tested his patch,
> but I don't know whether the patch needs to be further refined and tested.

Thanks for the information.  Do you have a pointer to the patch?

Rafael
