Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2BTREX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:04:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:21482 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2BTREX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:04:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68387841"
Date: Mon, 20 Feb 2012 18:11:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Chris Blair <chris.blair@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/stmpe: Add support for no-interrupt config
Message-ID: <20120220171130.GA7950@sortiz-mobl>
References: <1327400314-18030-1-git-send-email-linus.walleij@stericsson.com>
 <20120220170620.GG5387@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220170620.GG5387@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 06:06:20PM +0100, Samuel Ortiz wrote:
> Hi Linus,
> 
> On Tue, Jan 24, 2012 at 11:18:34AM +0100, Linus Walleij wrote:
> > From: Chris Blair <chris.blair@stericsson.com>
> > 
> > Adds support for boards which have an STMPE device without the
> > interrupt pin connected.
> Applied, thanks.
I applied v3 of this patch...

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
