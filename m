Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1DVXKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:10:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1DVXK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:10:29 -0400
Date: Fri, 22 Apr 2011 15:35:19 -0700
From: Greg KH <gregkh@suse.de>
To: james_p_freyensee@linux.intel.com
Cc: akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: export kernel call get_task_comm for driver use
Message-ID: <20110422223519.GB32459@suse.de>
References: <james_p_freyensee@linux.intel.com>
 <1303511188-728-1-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303511188-728-1-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 03:26:27PM -0700, james_p_freyensee@linux.intel.com wrote:
> >From an earlier submission by me it was suggested that this patch
> should go to Andrew for merging to be used by the pti driver
> I will be re-submitting shortly.
> 
> Once my device drivers are accepted into the kernel, I will try
> and help out to clean up the kernel a little from this
> patch that exports get_task_comm() that Andrew suggested. 
> I cannot promise a timeline or what I can fix, but I will
> look into fixing a few (Andrew found 89 potential cleanups).

I think the goal is for that cleanup to happen now, to justify the
addition of the exported symbol.  Without that, there is no need to
export the symbol now at all, as who knows when your driver will be
accepted.

Or, just wait and make it part of your driver patch series, like you did
before, no need to get it accepted now, right?

thanks,

greg k-h
