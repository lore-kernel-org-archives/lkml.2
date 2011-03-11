Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1CKPul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:50:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1CKPui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:50:38 -0500
Date: Fri, 11 Mar 2011 07:46:38 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/29] 2.6.37.4-stable review
Message-ID: <20110311154638.GA6579@suse.de>
References: <20110310235548.GA10103@kroah.com>
 <201103111602.26977.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103111602.26977.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 04:02:02PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 11 March 2011, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.37.r release.
> > There are 29 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Responses should be made by Saturday, March 12, 24:00:00 UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz
> 
> This seems to be still missing on kernel.org, is there an issue with 
> the mirroring?
> 
> $ LANG= wget kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz
> --2011-03-11 16:01:24--  http://kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz
> Resolving kernel.org... 130.239.17.4, 149.20.20.133, 199.6.1.164, ...
> Connecting to kernel.org|130.239.17.4|:80... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 2011-03-11 16:01:24 ERROR 404: Not Found.

Sorry, right after I sent out this announcement, the power went out here
where I live, and when it came on 3 hours later, the network wasn't back
on until this morning.  The file is now copied there and should show up
on the mirrors within 30 minutes.

thanks,

greg k-h
