Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0IURJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:09:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:36701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0IURJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:09:36 -0400
Date: Tue, 21 Sep 2010 10:08:07 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Cho <acho@novell.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for September 21 (staging/keucr)
Message-ID: <20100921170807.GB10105@suse.de>
References: <20100921170055.4512dd19.sfr@canb.auug.org.au>
 <20100921095345.af7d4978.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921095345.af7d4978.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 09:53:45AM -0700, Randy Dunlap wrote:
> On Tue, 21 Sep 2010 17:00:55 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100920:
> 
> 
> drivers/staging/keucr/smcommon.h:9:1: warning: "SUCCESS" redefined
> drivers/staging/built-in.o: In function `usb_stor_bulk_srb':
> (.text+0x5199e): multiple definition of `usb_stor_bulk_srb'

Hm, I don't think the keucr driver can be build into the kernel at the
moment, I'll go fix that.

thanks,

greg k-h
