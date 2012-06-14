Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2FNTR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:17:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41400 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2FNTR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:17:57 -0400
Date: Thu, 14 Jun 2012 12:17:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ning.n.jiang@gmail.com, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM: Deprecate suspend/resume in device_driver
Message-ID: <20120614191743.GA2721@kroah.com>
References: <1339656138-28060-1-git-send-email-ning.n.jiang@gmail.com>
 <20120614153730.GB17140@kroah.com>
 <201206142115.47601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206142115.47601.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 09:15:47PM +0200, Rafael J. Wysocki wrote:
> On Thursday, June 14, 2012, Greg KH wrote:
> > On Thu, Jun 14, 2012 at 02:42:17PM +0800, ning.n.jiang@gmail.com wrote:
> > > From: Ning Jiang <ning.n.jiang@gmail.com>
> > > 
> > > Make suspend/resume callbacks in device_driver deprecated and scheduled
> > > for removal since they are not used in PM core anymore.
> > > 
> > > Legacy drivers who still use them need to move suspend/resume callbacks
> > > to dev_pm_ops.
> > 
> > How many complier warnings does this patch produce?
> > 
> > Please fix them before submitting this patch.  The way kernel
> > development is is that you fix the problems up with the api, you don't
> > just mark them and hope someone else will do it for you.
> > 
> > Sorry, I can't take this.
> 
> Right.

To provide a bit more "constructive" review, the proper thing is to fix
up the whole kernel to never set these fields, and then just delete
them.  Ning, feel free to start working on that task, it's a good one to
accomplish and should be pretty well defined.

thanks,

greg k-h
