Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0JKRj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:39:57 -0400
Received: from kroah.org ([198.145.64.141]:52342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab0JKRjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:39:55 -0400
Date: Mon, 11 Oct 2010 10:25:30 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Al Cho <acho@novell.com>
Subject: Re: linux-next: Tree for October 11 (staging/keucr)
Message-ID: <20101011172530.GA7116@kroah.com>
References: <20101011162959.86e40961.sfr@canb.auug.org.au> <20101011094222.98a30bce.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011094222.98a30bce.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 09:42:22AM -0700, Randy Dunlap wrote:
> On Mon, 11 Oct 2010 16:29:59 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20101008:
> 
> 
> linux-next-20101011/drivers/staging/keucr/usb.c: In function 'get_transport':
> linux-next-20101011/drivers/staging/keucr/usb.c:346: error: 'US_PR_BULK' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/usb.c:346: error: (Each undeclared identifier is reported only once
> linux-next-20101011/drivers/staging/keucr/usb.c:346: error: for each function it appears in.)
> linux-next-20101011/drivers/staging/keucr/usb.c: In function 'get_protocol':
> linux-next-20101011/drivers/staging/keucr/usb.c:370: error: 'US_SC_SCSI' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/usb.c: In function 'get_pipes':
> linux-next-20101011/drivers/staging/keucr/usb.c:421: error: 'US_PR_CBI' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/usb.c: In function 'usb_stor_scan_thread':
> linux-next-20101011/drivers/staging/keucr/usb.c:567: error: 'US_PR_BULK' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/scsiglue.c: In function 'slave_alloc':
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:33: error: 'US_SC_UFI' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:33: error: (Each undeclared identifier is reported only once
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:33: error: for each function it appears in.)
> linux-next-20101011/drivers/staging/keucr/scsiglue.c: In function 'slave_configure':
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:58: error: 'US_SC_SCSI' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:58: error: 'US_SC_CYP_ATACB' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:79: error: 'US_PR_CB' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/scsiglue.c:79: error: 'US_PR_CBI' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/transport.c: In function 'usb_stor_invoke_transport':
> linux-next-20101011/drivers/staging/keucr/transport.c:318: error: 'US_PR_CB' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/transport.c:318: error: (Each undeclared identifier is reported only once
> linux-next-20101011/drivers/staging/keucr/transport.c:318: error: for each function it appears in.)
> linux-next-20101011/drivers/staging/keucr/transport.c:318: error: 'US_PR_DPCM_USB' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/transport.c:341: error: 'US_SC_RBC' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/transport.c:341: error: 'US_SC_SCSI' undeclared (first use in this function)
> linux-next-20101011/drivers/staging/keucr/transport.c:341: error: 'US_SC_CYP_ATACB' undeclared (first use in this function)
> In file included from linux-next-20101011/drivers/staging/keucr/smilmain.c:4:
> linux-next-20101011/drivers/staging/keucr/smcommon.h:9:1: warning: "SUCCESS" redefined
> In file included from linux-next-20101011/include/scsi/scsi_host.h:9,
>                  from linux-next-20101011/drivers/staging/keucr/usb.h:11,
>                  from linux-next-20101011/drivers/staging/keucr/smilmain.c:2:
> linux-next-20101011/include/scsi/scsi.h:429:1: warning: this is the location of the previous definition
> In file included from linux-next-20101011/drivers/staging/keucr/smilsub.c:9:
> linux-next-20101011/drivers/staging/keucr/smcommon.h:9:1: warning: "SUCCESS" redefined
> In file included from linux-next-20101011/include/scsi/scsi_host.h:9,
>                  from linux-next-20101011/drivers/staging/keucr/usb.h:11,
>                  from linux-next-20101011/drivers/staging/keucr/smilsub.c:2:
> linux-next-20101011/include/scsi/scsi.h:429:1: warning: this is the location of the previous definition
> In file included from linux-next-20101011/drivers/staging/keucr/smilecc.c:6:
> linux-next-20101011/drivers/staging/keucr/smcommon.h:9:1: warning: "SUCCESS" redefined
> In file included from linux-next-20101011/include/scsi/scsi_host.h:9,
>                  from linux-next-20101011/drivers/staging/keucr/usb.h:11,
>                  from linux-next-20101011/drivers/staging/keucr/smilecc.c:1:
> linux-next-20101011/include/scsi/scsi.h:429:1: warning: this is the location of the previous definition
> 
> 
> 
> config is attached.

Yes, this is known, I will fix it up when I merge the two trees
together, it's due to changes in the USB tree that are not in the
staging-next tree.

thanks,

greg k-h
