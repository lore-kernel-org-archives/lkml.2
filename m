Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0DZBjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 21:39:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44011 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753387Ab0DZBjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 21:39:15 -0400
Date: Sun, 25 Apr 2010 21:39:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: tytso@mit.edu, Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH 5/9] PM: suspend_block: Add debugfs file
In-Reply-To: <4BD4DCEA.8060602@oracle.com>
Message-ID: <Pine.LNX.4.44L0.1004252137480.1524-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Apr 2010, Randy Dunlap wrote:

> > Well, I'll note right now we have a somewhat annoying gap.  If you
> > need to export multiple values such that they are consistent with each
> > other, what's the choice?  /proc, where some (but not all) kernel
> > developers will say, "eeeeeeviilllll".  /sys is explicitly for single
> > value per files only.  And then we have /debugfs, where some pendants
> > are kvetching about whether something is "really" debug information.
> 
> First of all, I am not a pendant.

Are you sure about that?  At the moment, Arve may feel that you're 
hanging around his neck (although perhaps not looking very pretty!).
:-)

Alan Stern

