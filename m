Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0EEUVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:21:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45450 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab0EEUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:21:27 -0400
Date: Wed, 5 May 2010 21:21:07 +0100
From: Matthew Garrett <mjg@redhat.com>
To: mark gross <mgross@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100505202107.GA6655@srcf.ucam.org>
References: <20100504160346.GA27938@linux.intel.com> <Pine.LNX.4.44L0.1005041252480.1729-100000@iolanthe.rowland.org> <20100505015050.GA30591@linux.intel.com> <20100505133131.GA24477@srcf.ucam.org> <20100505200906.GA7450@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505200906.GA7450@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 01:09:06PM -0700, mark gross wrote:
> On Wed, May 05, 2010 at 02:31:31PM +0100, Matthew Garrett wrote:
> > But nobody has reasonably proposed one and demonstrated that it works. 
> > We've had over a year to do so and failed, and I think it's pretty 
> > unreasonable to ask Google to attempt to rearchitect based on a 
> > hypothetical.
> >
> 
> These are not new issues being raised. They've had over a year to
> address them, and all thats really happened was some sed script changes
> from wake_lock to suspend_blocker.  Nothing is really different
> here.

Our issues haven't been addressed because we've given no indication as 
to how they can be addressed. For better or worse, our runtime 
powermanagement story isn't sufficient to satisfy Google's usecases. 
That would be fine, if we could tell them what changes needed to be made 
to satisfy their usecases. The Android people have said that they don't 
see a cleaner way of doing this. Are we seriously saying that they 
should prove themselves wrong, and if they can't they don't get their 
code in the kernel? This seems... problematic.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
