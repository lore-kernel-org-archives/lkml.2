Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1BWXzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:55:08 -0500
Received: from kroah.org ([198.145.64.141]:50112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1BWXzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:55:06 -0500
Date: Wed, 23 Feb 2011 15:48:25 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Message-ID: <20110223234825.GB16936@kroah.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <20110223191533.GB1030@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56233FADA94@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20110223215658.GB16908@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56233FAE0E8@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56233FAE0E8@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:17:54PM +0000, Hank Janssen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Wednesday, February 23, 2011 1:57 PM
> > They where compile and run tested. And syslog was not a mess. What did
> > > I mess up here? The amount of printouts now are a fraction of what
> > > they where before.
> > 
> > You forgot to put '\n' at the end of all of your pr_XXX lines, so they will be
> > merged with the next one, messing up your syslog.  Joe also pointed this
> > problem out.
> > 
> > Take a look at your syslog to see what I am talking about...
> 
> I am trying to get some of these patches corrected and out today, but it might
> be tomorrow. So far I have lost power for a minutes or so twice this afternoon.

No rush, I've flushed out all of my staging tree patches today, so it
will be a number of days before I revisit them again.

thanks,

greg k-h
