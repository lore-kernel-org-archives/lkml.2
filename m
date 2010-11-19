Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0KSUgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:36:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab0KSUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:36:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shan Wei <shanwei@cn.fujitsu.com>
Subject: Re: [Bug #23092] WARNING in tty_io.c
Date: Fri, 19 Nov 2010 21:35:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera> <ATV3yiK8i4C.A.O7C.ehb5MB@chimera> <4CE5E3EE.1080104@cn.fujitsu.com>
In-Reply-To: <4CE5E3EE.1080104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192135.30477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Shan Wei wrote:
> Rafael J. Wysocki wrote, at 11/19/2010 07:42 AM:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23092
> > Subject		: WARNING in tty_io.c
> > Submitter	: Shan Wei <shanwei@cn.fujitsu.com>
> > Date		: 2010-11-10 8:06 (9 days old)
> > Message-ID	: <4CDA5291.4010802@cn.fujitsu.com>
> > References	: http://marc.info/?l=linux-kernel&m=128937645120159&w=2
> 
> It's not appreared in 2.6.37-rc2+ with top commit 59365d13.
> I don't know which patch/commit fix it.

OK, closed.

Rafael
