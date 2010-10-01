Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0JAVZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:25:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab0JAVZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:25:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Allow wakeup events to abort freezing of tasks
Date: Fri, 1 Oct 2010 23:24:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201009300016.50128.rjw@sisk.pl> <20100930142903.GA1442@ucw.cz>
In-Reply-To: <20100930142903.GA1442@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010012324.29283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 30, 2010, Pavel Machek wrote:
> On Thu 2010-09-30 00:16:50, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Allow wakeup events to abort freezing of tasks
> > 
> > If there is a wakeup event during the freezing of tasks, suspend or
> > hibernation will fail anyway.  Since try_to_freeze_tasks() can take
> > up to 20 seconds to complete or fail, aborting it as soon as a wakeup
> > event is detected improves the worst case wakeup latency.
> > 
> > Based on a patch from Arve Hj??nnev??g.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Ack.

Thanks!
