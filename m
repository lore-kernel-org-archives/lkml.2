Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2CFRma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:42:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:26858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab2CFRm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:42:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118277777"
Date: Tue, 6 Mar 2012 18:42:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, paul.gortmaker@windriver.com
Subject: Re: [PATCH 0/5] MFD: Reverting twl6040 patches going for 3.4
Message-ID: <20120306174213.GY9008@sortiz-mobl>
References: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Mar 06, 2012 at 02:35:11PM +0200, Peter Ujfalusi wrote:
> Hello Samuel,
> 
> this series reverts the twl6040 related patches aimed for 3.4 merge window from
> MFD for-next branch.
> As we already discussed the relevant patches will be going through audio since
> we have some dependencies going via that route.
I removed all 5 patches from my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
