Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1HIMsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1HIMst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:48:49 -0400
Date: Tue, 9 Aug 2011 08:48:43 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>
Subject: Re: exception in interrupt during elv_completed_request. (3.0)
Message-ID: <20110809124842.GA17607@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>
References: <20110808145826.GA22457@redhat.com>
 <4E3FFAB0.40205@fusionio.com>
 <20110808151352.GA24992@redhat.com>
 <4E3FFDB9.3090805@fusionio.com>
 <20110809054323.GA3653@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809054323.GA3653@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:43:23PM -0700, Greg Kroah-Hartman wrote:
 > On Mon, Aug 08, 2011 at 05:16:09PM +0200, Jens Axboe wrote:
 > > On 2011-08-08 17:13, Dave Jones wrote:
 > > >  > On 2011-08-08 16:58, Dave Jones wrote:
 > > >  > > Jens,
 > > >  > > 
 > > >  > > We got a report of a panic from a user when he plugged in his usb drive,
 > > >  > > https://bugzilla.redhat.com/attachment.cgi?id=517141
 > > >  > > 
 > > >  > > any ideas what happened here ?
 > > >  > 
 > > >  > 2.6.40?
 > > > 
 > > > it's 3.0 in all but name. didn't want to risk breaking dumb userspace
 > > > in an update for older fedora releases.  It does have the
 > > > scsi_dispatch_cmd fix that went into 3.0.1, but otherwise block/
 > > > should be stock 3.0
 > > 
 > > OK
 > > 
 > > >  > Looks like the recent SCSI removal oopses, perhaps it happened when he
 > > >  > yanked it instead of directly on insertion?
 > > >  
 > > > sorry my bad, yes, this was on device removal.
 > > > 
 > > > according to the user, he did everything right, and unmounted safely.	
 > > > https://bugzilla.redhat.com/show_bug.cgi?id=728872
 > > 
 > > James?
 > 
 > Should be resolved in 3.0.1 now.
 > 
 > If not, please let James, and me, know.

Are you talking about the scsi_dispatch_cmd fix ?  this is something else.

	Dave

