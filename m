Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1DESKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:10:23 -0400
Received: from kroah.org ([198.145.64.141]:33159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1DESKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:10:22 -0400
Date: Tue, 5 Apr 2011 11:08:16 -0700
From: Greg KH <greg@kroah.com>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
Subject: Re: [PATCH 1/1] staging: sep: remove dependency on memrar driver
Message-ID: <20110405180816.GA22846@kroah.com>
References: <1302023393-28057-1-git-send-email-mark.a.allyn@intel.com>
 <20110405172135.GA20622@kroah.com>
 <8A0E4C92AE2D6D40AF99653191DA32316154A37E9C@rrsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA32316154A37E9C@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 11:46:00AM -0600, Allyn, Mark A wrote:
> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> Sent: Tuesday, April 05, 2011 10:22 AM
> To: Allyn, Mark A
> Cc: linux-kernel@vger.kernel.org; alan@linux.intel.com; Epshteyn, Eugene
> Subject: Re: [PATCH 1/1] staging: sep: remove dependency on memrar driver
> 
> On Tue, Apr 05, 2011 at 10:09:53AM -0700, Mark Allyn wrote:
> > Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> > ---
> >  drivers/staging/sep/sep_driver.c |   59 +------------------------------------
> 
> Alan already sent me this patch, and it's in the staging-next tree,
> right?  Or is this a new one that I need to do on top of the current
> tree as I missed something?
> 
> thanks,
> 
> greg k-h
> 
> ==============
> 
> Greg:
> 
> I pulled next-20110405, along with 2.6.39-rc1 from kernel.org at about 9 AM
> on Tuesday, April 05, 2011.
> 
> I did not see it in that staging next. When will I see what Alan did on kernel.org?

Wait until the next linux-next release, I pushed out my tree late last
night.

thanks,

greg k-h
