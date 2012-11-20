Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2KTWnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:43:31 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56335 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab2KTWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:43:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcJALcGrFB5LbLL/2dsb2JhbABEvFeGAxdzgh4BAQU6HCMQCAMVAy4UJQMhE4gMDL8oBBSMIYR1A5V9kEKDAw
Date: Wed, 21 Nov 2012 09:43:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sendfile: allows bypassing of notifier events
Message-ID: <20121120224327.GJ2591@dastard>
References: <20121120163133.11806.15152.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120163133.11806.15152.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 04:31:34PM +0000, Alan Cox wrote:
> From: Scott Wolchok <swolchok@umich.edu>
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=12812

Please add a suitable commit message describing the bug and the fix.
Pointers to bug reports are good references, but they don't replace
a properly written commit message.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
