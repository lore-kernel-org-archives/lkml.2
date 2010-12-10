Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab0LJJmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 04:42:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:13608 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab0LJJmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 04:42:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208";a="359804335"
Date: Fri, 10 Dec 2010 10:42:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core interrupt ffs bit bug
Message-ID: <20101210094215.GB17051@sortiz-mobl>
References: <1291298809-3275-1-git-send-email-mattias.wallin@stericsson.com>
 <20101209121317.GE8884@sortiz-mobl>
 <4D01E26F.3090802@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D01E26F.3090802@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 09:18:55AM +0100, Mattias Wallin wrote:
> 
> 
> On 12/09/2010 01:13 PM, Samuel Ortiz wrote:
> > Hi Mattias,
> > 
> > On Thu, Dec 02, 2010 at 03:06:49PM +0100, Mattias Wallin wrote:
> >> This patch fixes a bug in ab8500 interrupt handling
> > Patch applied. This also looks like a good candidate for 2.6.37.
> I agree, AB8500 interrupts gets lost without this patch so the error is bad.
> Do you want me to do anything for this to happen?
No, the patch is already in my for-linus branch.

Cheers,
Samuel.


> > 
> > Cheers,
> > Samuel.
> > 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
