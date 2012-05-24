Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2EXCLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:11:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34059 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2EXCLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:11:13 -0400
Date: Wed, 23 May 2012 19:11:02 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: adl_pci7296: factor out the PCI device
 code
Message-ID: <20120524021102.GA12335@kroah.com>
References: <201205231428.48061.hartleys@visionengravers.com>
 <20120523214354.GQ4637@mwanda>
 <ADE657CA350FB648AAC2C43247A983F0020698BACAD5@AUSP01VMBX24.collaborationhost.net>
 <20120523220702.GR4637@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523220702.GR4637@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:07:02AM +0300, Dan Carpenter wrote:
> On Wed, May 23, 2012 at 04:52:47PM -0500, H Hartley Sweeten wrote:
> > On Wednesday, May 23, 2012 2:44 PM, Dan Carpenter wrote:
> > > Hartley, you're doing a great job with all these patches, but it's
> > > going to be weeks before the merge window closes.  We're going to
> > > end up getting confused with all the patches floating around.
> > 
> > I guess I should wait until the merge window closes and Greg starts
> > taking patches into the staging tree before continuing...
> > 
> 
> Wait!  No no.  The first answer was the right one, where you
> volunteered to do a bunch of work.

Yes, that's right, don't stop, I can queue these all up in my "to-apply"
mailbox just fine and will start applying them when 3.5-rc1 is out, to
my staging-next tree.  No need for you to take a break at all :)

thanks,

greg k-h
