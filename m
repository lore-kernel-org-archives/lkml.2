Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0GWTwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:52:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab0GWTw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:52:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Bug #15673] 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Date: Fri, 23 Jul 2010 21:50:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera> <PRbv8sgxY6G.A.nKH.yYYSMB@chimera> <1279897933.3126.1.camel@localhost.localdomain>
In-Reply-To: <1279897933.3126.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007232150.33454.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Thomas Meyer wrote:
> Am Freitag, den 23.07.2010, 14:15 +0200 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
> > Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2010-03-28 11:31 (118 days old)
> > Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
> > References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2
> > 
> > 
> 
> I also see this message in 2.6.35-rc6:

During suspend it seems?  Please attach the dmesg output to the bug entry
above.

Rafael
