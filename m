Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2KSRfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:35:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:36334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab2KSRfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:35:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,280,1352102400"; 
   d="scan'208";a="170207191"
Date: Mon, 19 Nov 2012 18:34:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org
Subject: Re: mfd: lpc_ich: NULL pointer dereference at (second) module removal
Message-ID: <20121119173456.GF18738@sortiz-mobl>
References: <1352467148.1895.20.camel@x61.thuisdomein>
 <1352741475.6008.16.camel@petert>
 <20121119002404.GD18738@sortiz-mobl>
 <1353330169.19434.7.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353330169.19434.7.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Nov 19, 2012 at 02:02:49PM +0100, Paul Bolle wrote:
> On Mon, 2012-11-19 at 01:24 +0100, Samuel Ortiz wrote:
> > I just merged commit
> > 5dc4dda91c86ef82bd53d77e5de50ec095b33e46 into my for-next branch and that one
> > could fix that issue. Could you guys please give it a go ?
> 
> 0) Applies cleanly to v3.6.7. Compiles cleanly too. No oops after the
> (second or later) removal of lpc_ich. So this patch seems to do the
> trick.
Thanks for the feedback.


> 1) Could you please send this patch to stable too (when it finally hits
> mainline, that is)? A quick glance suggests it can be backported to as
> far v3.0 (but I only tested v3.6.y, see above).
Yep, I'll cc stable on it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
