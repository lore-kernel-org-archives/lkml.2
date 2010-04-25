Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0DYSOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 14:14:39 -0400
Received: from kroah.org ([198.145.64.141]:51322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab0DYSOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 14:14:38 -0400
Date: Sun, 25 Apr 2010 11:15:17 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
Message-ID: <20100425181517.GA22676@kroah.com>
References: <1271984938-13920-1-git-send-email-arve@android.com> <1271984938-13920-2-git-send-email-arve@android.com> <1271984938-13920-3-git-send-email-arve@android.com> <1271984938-13920-4-git-send-email-arve@android.com> <1271984938-13920-5-git-send-email-arve@android.com> <1271984938-13920-6-git-send-email-arve@android.com> <20100423135853.478af057.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423135853.478af057.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 01:58:53PM -0700, Randy Dunlap wrote:
> On Thu, 22 Apr 2010 18:08:54 -0700 Arve Hj?nnev?g wrote:
> 
> > Report active and inactive suspend blockers in
> > /sys/kernel/debug/suspend_blockers.
> 
> 
> This looks more like user interface information than it does debug information.
> If that's correct, it shouldn't be in debugfs.

It's debug-like information, and has more than one value per file, so
debugfs seems like the proper place for it.  I have no objection to it
going there.

thanks,

greg k-h
