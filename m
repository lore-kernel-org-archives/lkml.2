Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0IPTbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:31:00 -0400
Received: from kroah.org ([198.145.64.141]:50514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab0IPTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:30:58 -0400
Date: Thu, 16 Sep 2010 12:28:31 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        Al Cho <acho@novell.com>, driverdevel <devel@driverdev.osuosl.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging/keucr: update TODO list and ask question
 about it
Message-ID: <20100916192831.GB10397@kroah.com>
References: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
 <20100914154148.826a0334.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914154148.826a0334.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:41:48PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Update keucr TODO with additional work items.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Al Cho <acho@novell.com>
> ---
>  drivers/staging/keucr/TODO |    3 +++
>  1 file changed, 3 insertions(+)
> 
> and I don't understand this TODO comment:
> "	- determine if the driver should not be using a duplicate
> 	  version of the usb-storage scsi interface code, but should
> 	  be merged into the drivers/usb/storage/ directory and
> 	  infrastructure instead."
> 
> Of course the driver should not use a duplicate of the usb-storage
> SCSI interface code.  Did someone seriously think that it should?

Well, it's not the whole copy, and we are still trying to unwind the
hooks here.  It might be that this is just another scsi driver, one that
happens to also be a USB device, as I don't think this device follows
the usb-storage spec at all.

So it's still an unanswered question.

thanks,

greg k-h
