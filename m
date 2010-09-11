Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0IKDB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:01:28 -0400
Received: from kroah.org ([198.145.64.141]:44775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab0IKDB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:01:28 -0400
Date: Fri, 10 Sep 2010 17:56:11 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, Kconfig fix
Message-ID: <20100911005611.GA20937@kroah.com>
References: <1284162665.16135.3.camel@odc-laptop> <20100911001005.GA20027@kroah.com> <B04B456200E54B21903A74C16B359CC8@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B04B456200E54B21903A74C16B359CC8@stanford.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 05:20:49PM -0700, David Cross wrote:
> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> 
> On Fri, Sep 10, 2010 at 04:51:05PM -0700, David Cross wrote:
> > > This patch fixes the currently broken Kconfig for west bridge by
> > > introducing a dependency on a valid HAL Layer for the driver build.
> > > 
> > > Signed-off-by: David Cross <david.cross@cypress.com>
> 
> > Which order do these 4 patches need to be applied in?  Please read
> > section 15 in Documentation/SubmittingPatches for details as to how to
> > properly format things.
> 
> No ordering is necessary for these specific patches, they are all
> independent. 

Ok.

> Re-reading SubmittingPatches document, I am not totally sure if you are
> referring to ordering (which is not needed in this case), or the actual
> format in section 15. Would you like me to re-submit with a "from", empty
> line, and a ":" in the subject?
> Please let me know.

No, that's fine, I was referring to the typical [01/04] numbering that
people use to ensure both the order, and the fact that all patches go
through.

thanks,

greg k-h
