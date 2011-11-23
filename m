Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1KWT6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:58:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab1KWT6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:58:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5] PM: Update comments describing device power management callbacks
Date: Wed, 23 Nov 2011 21:01:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Ming Lei <tom.leiming@gmail.com>
References: <Pine.LNX.4.44L0.1111231127370.2111-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111231127370.2111-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111232101.36188.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 23, 2011, Alan Stern wrote:
> On Wed, 23 Nov 2011, Rafael J. Wysocki wrote:
> 
> > On Tuesday, November 22, 2011, Alan Stern wrote:
> > > On Tue, 22 Nov 2011, Rafael J. Wysocki wrote:
> > > 
> > > > > The same data structure (dev_pm_ops) is used for both drivers and
> > > > > subsystems.  Therefore the comments should be directed toward both
> > > > > driver writers and subsystem writers.
> > > > 
> > > > I don't quite agree.  Trying to do so would turn that comment into a lengthy
> > > > document and there's no room for anything like that in the header file.
> > > 
> > > That's a good point.
> > > 
> > > > Perhaps I'll just modify the comment to say when the callbacks are executed
> > > > without specifying what the specific callbacks are supposed to do (because
> > > > that may vary from one subsystem to another and even between different
> > > > drivers belonging to the same subsystem).  If PM domains are taken into
> > > > account, it gets even more complicated.
> > > 
> > > Yes, a minimal description would be good, along with a pointer to the 
> > > Documentation/power files.
> > 
> > Well, the one below is not exactly minimal, but I think it doesn't go too
> > far at least.
> 
> Yes, I like this version better.

Great, thanks!

Rafael
