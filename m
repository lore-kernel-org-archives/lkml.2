Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1BHPcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:32:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55577 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752380Ab1BHPcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:32:46 -0500
Date: Tue, 8 Feb 2011 10:32:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH wq#for-2.6.39] workqueue: add system_freezeable_wq
In-Reply-To: <20110208151453.GC6558@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1102081029430.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Tejun Heo wrote:

> On Tue, Feb 08, 2011 at 10:10:46AM -0500, Alan Stern wrote:
> > On Tue, 8 Feb 2011, Tejun Heo wrote:
> > 
> > > From de62c151df9b6568c67977920267392c432f340a Mon Sep 17 00:00:00 2001
> > > From: Tejun Heo <tj@kernel.org>
> > > Date: Tue, 8 Feb 2011 10:39:03 +0100
> > > 
> > > Add system wide freezeable workqueue.
> > 
> > The preferred spelling is "freezable".
> 
> Hmmm... workqueue always has used freezeable (even before cmwq
> changes).  It seems like mass renaming is in order.  :-(

The name of create_freezeable_workqueue was misspelled originally and
then never changed.  But other code and most of the comments and 
documentation are spelled correctly -- grep for both spellings and 
you'll see.

Agreed, some renaming and editing is in order.

Alan Stern

