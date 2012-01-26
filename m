Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2AZRur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:50:47 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42681 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab2AZRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:50:46 -0500
Message-ID: <1327600244.6151.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <gregkh@suse.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, hch@infradead.org, linux-scsi@vger.kernel.org
Date: Thu, 26 Jan 2012 11:50:44 -0600
In-Reply-To: <20120126173751.GA14400@suse.de>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
	 <1327599515-12679-1-git-send-email-kys@microsoft.com>
	 <20120126173751.GA14400@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 09:37 -0800, Greg KH wrote:
> On Thu, Jan 26, 2012 at 09:38:34AM -0800, K. Y. Srinivasan wrote:
> > This patch gets the storage driver to the same level as in the staging tree.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/staging/hv/storvsc_drv.c | 1301 ++++++++++++++++++-------------------
> >  1 files changed, 633 insertions(+), 668 deletions(-)
> 
> What?  That changelog comment makes no sense at all, as you are patching
> the staging version of the driver.  This isn't an acceptable patch at
> all.

Agreed

> Yes, I have pending patches for this driver in my "to-apply" queue, but
> that is for 3.4, not now.
> 
> So, how about I just apply those patches, and then apply a patch that
> moves it out of staging into drivers/scsi/, and queue all of those up
> for 3.4.
> 
> James, any objection to that?

Well, we were going to try to stage this driver for 3.3-rc.  If everyone
agrees to push it back to 3.4, then this works for me.

James


