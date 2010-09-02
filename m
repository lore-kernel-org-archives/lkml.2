Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0IBU1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:27:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37265 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751091Ab0IBU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:27:32 -0400
Date: Thu, 2 Sep 2010 16:27:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Colin Cross <ccross@android.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after
 abort
In-Reply-To: <201009022146.03359.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1009021626110.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Rafael J. Wysocki wrote:

> On Thursday, September 02, 2010, Alan Stern wrote:
> > On Wed, 1 Sep 2010, Colin Cross wrote:
> > 
> > > Only wait on a parent device during resume if the parent device is
> > > suspended.

> > I think it would be better to change device_pm_init() and add a 
> > complete_all().
> 
> I agree.
> 
> Who's writing the patch?

I was hoping that Colin would.  But I can do it if he doesn't want to.

Alan Stern

