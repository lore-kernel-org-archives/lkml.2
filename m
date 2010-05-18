Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0ERWLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:11:36 -0400
Received: from kroah.org ([198.145.64.141]:47820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab0ERWLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:11:34 -0400
Date: Tue, 18 May 2010 15:03:34 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Rankilor <reodge@gmail.com>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Bernd Porr <berndporr@f2s.com>, Gorskin Ilya <revent82@gmail.com>
Subject: Re: [PATCH] staging/comedi/comedi.h: cleanups
Message-ID: <20100518220334.GA9058@kroah.com>
References: <1273746519-4590-1-git-send-email-reodge@gmail.com>
 <1273746519-4590-2-git-send-email-reodge@gmail.com>
 <1273747232.21514.22.camel@Joe-Laptop.home>
 <20100514205023.GA23779@kroah.com>
 <20100514205114.GA27844@kroah.com>
 <1274040918.1705.432.camel@Joe-Laptop.home>
 <20100518214213.GA6764@kroah.com>
 <1274219526.17703.119.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274219526.17703.119.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 02:52:06PM -0700, Joe Perches wrote:
> On Tue, 2010-05-18 at 14:42 -0700, Greg KH wrote:
> > On Sun, May 16, 2010 at 01:15:18PM -0700, Joe Perches wrote:
> > > Just general neatening, reduces checkpatch plaints
> > > from 15 to 3.
> > >  drivers/staging/comedi/comedi.h | 1410 ++++++++++++++++++++-------------------
> > What tree did you make this against?
> 
> linux-next, after you pulled a9560a72759c6208c4072a30fb45aac7c6c014d4

Sorry, there was some other comedi.h changes that came in after that.
Care to respin this on linux-next for tomorrow?

thanks,

greg k-h
