Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2DPRqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:46:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:44582 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2DPRqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:46:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="130249952"
Date: Mon, 16 Apr 2012 19:55:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 0/2] MFD and GPIO for STA2X11
Message-ID: <20120416175522.GU24130@sortiz-mobl>
References: <cover.1334219873.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1334219873.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Thu, Apr 12, 2012 at 10:48:32AM +0200, Alessandro Rubini wrote:
> These two patches introduce the multi-function device and GPIO support for
> the STA2X11 I/O Hub.  Core PCI support is already in linux-next.
> 
> V1: sent on Jan 26th as RFC and got no comments back
> 
> V2: sent on Feb 16th, fixed a number of minor details, got comments from
> Linus Walleij and Samuel Ortiz.
> 
> V3: accepted all suggestions.  I delayed this resending a while because
> I hoped the base STA2X11 patches to be accepted, but despite the positive
> comments I got on those patches, they are not in linux-next as of today
There was a misunderstanding here: I was expecting a new patchset from you
before applying it, since v2 had some unresolved comments.
In fact, there are still some minor issues with it, see my comments on the MFD
patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
