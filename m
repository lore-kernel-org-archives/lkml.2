Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2FNTKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:10:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2FNTK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:10:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] PM: Deprecate suspend/resume in device_driver
Date: Thu, 14 Jun 2012 21:15:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: ning.n.jiang@gmail.com, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <1339656138-28060-1-git-send-email-ning.n.jiang@gmail.com> <20120614153730.GB17140@kroah.com>
In-Reply-To: <20120614153730.GB17140@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206142115.47601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 14, 2012, Greg KH wrote:
> On Thu, Jun 14, 2012 at 02:42:17PM +0800, ning.n.jiang@gmail.com wrote:
> > From: Ning Jiang <ning.n.jiang@gmail.com>
> > 
> > Make suspend/resume callbacks in device_driver deprecated and scheduled
> > for removal since they are not used in PM core anymore.
> > 
> > Legacy drivers who still use them need to move suspend/resume callbacks
> > to dev_pm_ops.
> 
> How many complier warnings does this patch produce?
> 
> Please fix them before submitting this patch.  The way kernel
> development is is that you fix the problems up with the api, you don't
> just mark them and hope someone else will do it for you.
> 
> Sorry, I can't take this.

Right.

Please disregard my previous message, I sent it before reading this one.

Thanks,
Rafael
