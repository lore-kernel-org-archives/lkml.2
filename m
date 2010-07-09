Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0GIVD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:03:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab0GIVD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:03:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
Date: Fri, 9 Jul 2010 23:01:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.YHB.IMmNMB@chimera> <201007082300.51672.shawn.starr@rogers.com>
In-Reply-To: <201007082300.51672.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092301.25839.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Shawn Starr wrote:
> On Thursday, July 08, 2010 07:41:40 pm Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16311
> > Subject		: [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500
> > laptop Submitter	: Shawn Starr <shawn.starr@rogers.com>
> > Date		: 2010-06-28 0:45 (11 days old)
> > Message-ID	: <201006272045.17004.shawn.starr@rogers.com>
> > References	: http://marc.info/?l=linux-kernel&m=127768633705286&w=2
> 
> Continues with July 7th, snapshot of 2.6.35-rc4. 
> 
> Some more info: I have USB in use while trying to suspend.  A USB Microsoft 
> Mouse and a QuickCam Pro 9000 camera connected.

Well, can you please try to suspend without the USB devices and see if the bug
is still reproducible, then?

Rafael
