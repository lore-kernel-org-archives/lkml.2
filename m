Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2FLDIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:08:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:53512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2FLDIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151687501"
Message-ID: <1339470490.7404.34.camel@yhuang-dev>
Subject: Re: [BUGFIX] ACPI, APEI, Avoid too much error reporting in runtime
From: Huang Ying <ying.huang@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Date: Tue, 12 Jun 2012 11:08:10 +0800
In-Reply-To: <1339421127.4942.8.camel@deadeye.wl.decadent.org.uk>
References: <1339395822-12032-1-git-send-email-ying.huang@intel.com>
	 <1339421127.4942.8.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 14:25 +0100, Ben Hutchings wrote:
> On Mon, 2012-06-11 at 14:23 +0800, Huang Ying wrote:
> > This patch fixed the following bug.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=43282
> > 
> > This is caused by a firmware bug checking (checking generic address
> > register provided by firmware) in runtime.  The checking should be
> > done in address mapping time instead of runtime to avoid too much
> > error reporting in runtime.
> > 
> > Reported-by: Pawel Sikora <pluto@agmk.net>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Tested-by: Jean Delvare <khali@linux-fr.org>
> [...]
> 
> This is not the correct way to submit a patch for stable.  See
> Documentation/stable_kernel_rules.txt.

Thanks for reminding.  Will resend the patch.

Best Regards,
Huang Ying

