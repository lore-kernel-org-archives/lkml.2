Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1K0JcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:32:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44326 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab1K0JcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:32:14 -0500
X-Sasl-enc: SvMKGlN5qlm11VvS3MSJPYm2VAQvsb7b9tnKa4Rir9vU 1322386332
Date: Sat, 26 Nov 2011 17:13:01 -0800
From: Greg KH <greg@kroah.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Ken O'Brien" <kernel@kenobrien.org>, lucas.demarchi@profusion.mobi,
        devel@driverdev.osuosl.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: bcm: Adapter.h Checkpatch cleaning.
Message-ID: <20111127011301.GA2564@kroah.com>
References: <1321669194-4365-1-git-send-email-kernel@kenobrien.org>
 <20111119071915.GJ29436@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119071915.GJ29436@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 10:19:15AM +0300, Dan Carpenter wrote:
> On Sat, Nov 19, 2011 at 02:19:54AM +0000, Ken O'Brien wrote:
> > Removed all checkpatch errors.
> > 
> > Checkpatch status before: total: 131 errors, 200 warnings, 648 lines checked
> > Checkpatch status after:  total: 0 errors, 194 warnings, 620 lines checked
> > 
> 
> I don't have strong opinions personally, but I think the prefered way
> is to do this for one class of errors at a time.  It makes the patch
> smaller and easier to review.  Then send the series of patches.

Yes, that is my prefered way as well.

thanks,

greg k-h
