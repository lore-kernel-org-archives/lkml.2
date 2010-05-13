Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0EMFyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:54:50 -0400
Received: from kroah.org ([198.145.64.141]:39777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab0EMFys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:54:48 -0400
Date: Wed, 12 May 2010 22:51:13 -0700
From: Greg KH <greg@kroah.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Add x64 support to debugfs
Message-ID: <20100513055113.GA27033@kroah.com>
References: <1273653641-4519-1-git-send-email-ying.huang@intel.com> <1273653641-4519-2-git-send-email-ying.huang@intel.com> <20100512214737.GA27785@kroah.com> <1273710327.3564.61.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273710327.3564.61.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:25:27AM +0800, Huang Ying wrote:
> On Thu, 2010-05-13 at 05:47 +0800, Greg KH wrote:
> > On Wed, May 12, 2010 at 04:40:40PM +0800, Huang Ying wrote:
> > > Add debugfs_create_x64. This is needed by ACPI APEI EINJ parameters support.
> > > 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > CC: Greg KH <greg@kroah.com>
> > 
> > Do you want me to take this through my tree?  Or should it go through
> > the acpi one as you depend on it?
> > 
> > If so, that's fine with me, feel free to add:
> > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > to the patch then.
> 
> Thank you very much for you kindness. Cross tree merging is pain, so I
> want to go through the ACPI tree to make it easier.

Great, Len, feel free to take this through your tree.

thanks,

greg k-h
