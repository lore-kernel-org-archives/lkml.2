Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072Ab2EXG2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:28:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27695 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2EXG2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:28:44 -0400
Date: Thu, 24 May 2012 09:32:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: adl_pci7296: factor out the PCI device
 code
Message-ID: <20120524063232.GT4637@mwanda>
References: <201205231428.48061.hartleys@visionengravers.com>
 <20120523214354.GQ4637@mwanda>
 <ADE657CA350FB648AAC2C43247A983F0020698BACACF@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698BACACF@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 04:43:34PM -0500, H Hartley Sweeten wrote:
> On Wednesday, May 23, 2012 2:44 PM, Dan Carpenter wrote:
> > Hartley, you're doing a great job with all these patches, but it's
> > going to be weeks before the merge window closes.  We're going to
> > end up getting confused with all the patches floating around.
> >
> > Do you think you could maybe put up a git tree with the current
> > stuff so people know when they're stepping on each other's toes?
> 
> I would but really don't know how/were to put one.
> 

I can't speak for Greg but probably he'd still end up taking patches
from the list, not from the git tree.  So that makes it less of a
big deal where you put it, since we'd only use it to just track
which patches are out there.

So if someone submits a patch to comedi, we'd tell them, "Uh.  This
conflicts with some previously submitted patches.  Please pull from
Hartley's tree and modify it so it applies."

There are several free git hosting projects out there.  I use
http://repo.or.cz/ for Smatch.

> Also, I'm still a bit of a newbie with git. I would need some help
> initially to make sure I didn't screw it up. ;-)

Register a project.
Do a fork of http://repo.or.cz/w/linux-2.6.git
Push Greg's stuff.
Go through the email list and download all the comedi patches which
Greg doesn't have (raw emails including headers and everything).

cat email.txt | git am -s

If it doesn't apply complain to the submitter.  Don't fix anyone's
patches or changelogs.  Just complain and make them do the work.

Make sure when you apply a patch that the authorship information is
preserved.

git push ssh://yourname@repo.or.cz/srv/git/project.git master

regards,
dan carpenter
