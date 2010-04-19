Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0DSRtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:49:23 -0400
Received: from kroah.org ([198.145.64.141]:50983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab0DSRtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:49:22 -0400
Date: Mon, 19 Apr 2010 10:44:53 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>, Mike Snitzer <snitzer@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Wysochanski <dwysocha@redhat.com>,
       Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [stable] [patch 114/123] dm ioctl: only issue uevent on resume
 if state	changed
Message-ID: <20100419174453.GB32347@kroah.com>
References: <20100313001618.GA9811@kroah.com>
 <20100313001515.103664129@kvm.kroah.org>
 <20100322184314.GA7534@redhat.com>
 <20100322185409.GL919@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322185409.GL919@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 06:54:09PM +0000, Alasdair G Kergon wrote:
> On Mon, Mar 22, 2010 at 02:43:17PM -0400, Mike Snitzer wrote:
> > The following upstream dm-ioctl patch also needs to go to stable now
>  
> Ack.
> 
> This is for the benefit of systems that have switched over to using udev
> rules to manage dm devices (instead of dm/lvm2 code).  The userspace
> code that issued the ioctl needs to be told whether or not a uevent was
> issued so that it knows whether or not there is udev processing to wait
> for.

Ok, it's now queued up, thanks for letting me know.

greg k-h
