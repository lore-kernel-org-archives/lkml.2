Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0IAThB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:37:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0IATg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:36:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bug #16771] [Bisected Regression in 2.6.35] A full tmpfs filesystemcauses hibernationto hang
Date: Wed, 1 Sep 2010 21:35:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <4C7D146E.8020601@superonline.com> <201008312219.39694.rjw@sisk.pl> <20100901102757.974A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100901102757.974A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009012135.22956.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 01, 2010, KOSAKI Motohiro wrote:
> > On Tuesday, August 31, 2010, M. Vefa Bicakci wrote:
> > > On 30/08/10 02:13 AM, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of regressions introduced between 2.6.34 and 2.6.35.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > > > be listed and let the tracking team know (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16771
> > > > Subject		: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
> > > > Submitter	: M. Vefa Bicakci <bicave@superonline.com>
> > > > Date		: 2010-08-15 5:25 (15 days old)
> > > > First-Bad-Commit: http://git.kernel.org/linus/bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> > > > Message-ID	: <4C677A49.4030904@superonline.com>
> > > > References	: http://marc.info/?l=linux-kernel&m=128184995401968&w=2
> > > > 
> > > 
> > > Dear Rafael Wysocki,
> > > 
> > > This regression still exists in 2.6.35.4. (I haven't tested 2.6.36-rcX
> > > series.) Kosaki Motohiro has kindly helped me with this issue and found
> > > a fix for the regression. Today I have successfully tested his patch,
> > > but I don't know whether the patch needs to be further refined and tested.
> > 
> > Thanks for the information.  Do you have a pointer to the patch?
> 
> http://lkml.org/lkml/2010/8/31/429

Thanks, I updated the bug entry with the patch information.

Rafael
