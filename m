Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0KSVEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:04:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53139 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab0KSVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:04:46 -0500
Date: Fri, 19 Nov 2010 13:03:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shan Wei <shanwei@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #23092] WARNING in tty_io.c
Message-Id: <20101119130349.4430e1d1.randy.dunlap@oracle.com>
In-Reply-To: <201011192135.30477.rjw@sisk.pl>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
	<ATV3yiK8i4C.A.O7C.ehb5MB@chimera>
	<4CE5E3EE.1080104@cn.fujitsu.com>
	<201011192135.30477.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 21:35:30 +0100 Rafael J. Wysocki wrote:

> On Friday, November 19, 2010, Shan Wei wrote:
> > Rafael J. Wysocki wrote, at 11/19/2010 07:42 AM:
> > > This message has been generated automatically as a part of a summary report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > > know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23092
> > > Subject		: WARNING in tty_io.c
> > > Submitter	: Shan Wei <shanwei@cn.fujitsu.com>
> > > Date		: 2010-11-10 8:06 (9 days old)
> > > Message-ID	: <4CDA5291.4010802@cn.fujitsu.com>
> > > References	: http://marc.info/?l=linux-kernel&m=128937645120159&w=2
> > 
> > It's not appreared in 2.6.37-rc2+ with top commit 59365d13.
> > I don't know which patch/commit fix it.
> 
> OK, closed.

I can still reproduce it on 2.6.37-rc2-git4.
I'll send a separate problem report on it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
