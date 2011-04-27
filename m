Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab1D0Pcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:32:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:46104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab1D0Pcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:32:46 -0400
Date: Wed, 27 Apr 2011 08:33:35 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Oren Weil <oren.jer.weil@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 6/8] staging/mei: Header file contain the Userland API,
 (IOCTL and its struct)
Message-ID: <20110427153335.GA25973@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
 <20110427081541.80cc591a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427081541.80cc591a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 08:15:41AM -0700, Randy Dunlap wrote:
> On Wed, 27 Apr 2011 13:27:35 +0300 Oren Weil wrote:
> 
> 
> > +/*
> > + * This IOCTL is used to associate the current file descriptor with a
> > + * FW Client (given by UUID). This opens a communication channel
> > + * between a host client and a FW client. From this point every read and write
> > + * will communicate with the associated FW client.
> > + * Only in close() (file_operation release()) the communication between
> > + * the clients is disconnected
> > + *
> > + * The IOCTL argument is a struct with a union the contains
> > + * the input parameter and the output parameter for this IOCTL.
> > + *
> > + * The input parameter is UUID of the FW Client.
> > + * The output parameter is the properties of the FW client
> > + * (FW protocol version and max message size).
> > + *
> > + */
> > +#define IOCTL_MEI_CONNECT_CLIENT \
> > +	_IOWR('H' , 0x01, struct mei_connect_client_data)
> 
> 
> Please update Documentation/ioctl/ioctl-number.txt.

Not yet, this code might get that ioctl removed before it gets merged
into the main part of the kernel.

Or at least I can hope :)

thanks,

greg k-h
