Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2LGAtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:49:19 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56077 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab2LGAtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:49:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4NALs7wVB5LHa//2dsb2JhbABEuECFehdzgh4BAQU6HCMQCAMOCi4UJQMhE4gPwn0UjCUKg1hhA5YCkEiDBw
Date: Fri, 7 Dec 2012 11:49:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@whamcloud.com>
Cc: yangsheng <sickamd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "adilger@dilger.ca" <adilger@dilger.ca>
Subject: Re: [PATCH] Update atime from future.
Message-ID: <20121207004910.GD27172@dastard>
References: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
 <20121204202416.GB9451@dastard>
 <424C1F3A-E96F-485B-BAE5-02CE41C0DBFF@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <424C1F3A-E96F-485B-BAE5-02CE41C0DBFF@whamcloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 05:22:32PM -0700, Andreas Dilger wrote:
> The point is that the behaviour before the relatime patch was that
> the kernel updated the atime to the current time as the kernel
> knows about it, it didn't make any decision about "the past" or
> "the future".
> 
> Relatime is about reducing the frequency of atime updates, not
> about deciding that one timestamp is more correct than another. 

That makes sense.

Indeed, that's what the commit message should say rather than
drawing arbitrary lines in the sand about what is a valid atime
without further justification.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
