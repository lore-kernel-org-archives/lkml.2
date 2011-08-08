Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1HHPN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:13:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1HHPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:13:55 -0400
Date: Mon, 8 Aug 2011 11:13:52 -0400
From: Dave Jones <davej@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: exception in interrupt during elv_completed_request. (3.0)
Message-ID: <20110808151352.GA24992@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110808145826.GA22457@redhat.com>
 <4E3FFAB0.40205@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3FFAB0.40205@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 05:03:12PM +0200, Jens Axboe wrote:
 > On 2011-08-08 16:58, Dave Jones wrote:
 > > Jens,
 > > 
 > > We got a report of a panic from a user when he plugged in his usb drive,
 > > https://bugzilla.redhat.com/attachment.cgi?id=517141
 > > 
 > > any ideas what happened here ?
 > 
 > 2.6.40?

it's 3.0 in all but name. didn't want to risk breaking dumb userspace in an update
for older fedora releases.  It does have the scsi_dispatch_cmd fix that went into 3.0.1,
but otherwise block/ should be stock 3.0

 > Looks like the recent SCSI removal oopses, perhaps it happened when he
 > yanked it instead of directly on insertion?
 
sorry my bad, yes, this was on device removal.

according to the user, he did everything right, and unmounted safely.	
https://bugzilla.redhat.com/show_bug.cgi?id=728872

	Dave

