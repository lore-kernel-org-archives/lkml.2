Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1CKAK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:10:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab1CKAK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:10:26 -0500
Subject: Re: isci for 2.6.39?
From: James Bottomley <James.Bottomley@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>,
        Jacek Danecki <jacek.danecki@intel.com>,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>
In-Reply-To: <1299801757.8641.21.camel@dwillia2-linux>
References: <1299801757.8641.21.camel@dwillia2-linux>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 18:10:19 -0600
Message-ID: <1299802219.11933.175.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 16:02 -0800, Dan Williams wrote:
> Given the impending opening of the 2.6.39 merge window I would like to
> discuss the options for merging the isci driver.  Review has been
> intermittent which is understandable given the size and flux of the
> codebase.  It has received a good amount of cleanups, but additional
> review issues and cleanups are still all too easy to spot.  I know you
> have expressed reservations about taking scsi drivers through -staging
> in the past [1], so I would like to propose an alternative.  Merge the
> driver into scsi-misc but with a -staging style TODO file that tracks
> the review issues.  If the TODO file is not addressed by the 2.6.40
> window the driver would be moved to -staging.  This has the benefit of
> keeping the driver under your purview and expected location, but still
> have the imminent prospect of being de-staged to ensure the community's
> concerns are ultimately addressed.  We fully intend to maintain the
> current momentum on the driver cleanup effort and be ready in advance of
> 2.6.40.

Given that you only posted the core files today, I think it's a bit late
for the 2.6.39 merge window, which will be opening in under a week.

You could send it all to staging ... it's just that pretty much seems to
guarantee no SCSI review, which is what you seem to need at the moment.

> As a side note I'm still looking for a disposition for:
> "libsas: flush initial device discovery before completing ->scan_finished()" [2]
> "libsas: fix/amend device gone notification in sas_deform_port()" [3]

I thought I commented ... I'll go back and dig them out of email.

James


