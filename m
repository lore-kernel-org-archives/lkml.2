Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2DWIN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:13:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:37815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2DWINZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144755223"
Date: Mon, 23 Apr 2012 10:13:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Heasley, Seth" <seth.heasley@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: Re: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Message-ID: <20120423081316.GA14577@sortiz-mobl>
References: <1334696962-3642-1-git-send-email-seth.heasley@intel.com>
 <20120418101802.GD1204@sortiz-mobl>
 <DEC3922D1904474A8862C7BFF516EA9A41A5CB9B@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DEC3922D1904474A8862C7BFF516EA9A41A5CB9B@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, Apr 18, 2012 at 03:59:49PM +0000, Heasley, Seth wrote:
> Hi Samuel,
> 
> >Is the pci_ids.h change already in ? If not, I should take it at the
> >same time so that we don't break compilation.
> 
> It was submitted just prior to my sending this patch.
Please send it to me as your MFD patch build depends on it and it should be
committed first.



> >> @@ -68,7 +69,7 @@ static struct resource wdt_sch_resource = {
> >>
> >>  static struct mfd_cell tunnelcreek_cells[] = {
> >>  	{
> >> -		.name = "tunnelcreek_wdt",
> >> +		.name = "ie6xx_wdt",
> >>  		.num_resources = 1,
> >>  		.resources = &wdt_sch_resource,
> >>  	},
> >This one should be part of your upcoming watchdog driver patch (as a
> >separate patch that I'd take).
> 
> I'm actually not submitting a watchdog patch.  The maintainer already has code for this driver and is converting it to the new watchdog API.  In discussions with him, we agreed to the renaming of the driver, which was submitted for a previous platform.  He'll be committing the new code in the next couple of weeks, so I made this change in anticipation of the driver making it upstream.
>
That's reasonable, but I'd prefer this naming change to happen when the
watchdog patch is submitted as well, as a separate MFD one liner patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
