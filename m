Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0DZAgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 20:36:48 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:55760 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751796Ab0DZAgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 20:36:46 -0400
Date: Mon, 26 Apr 2010 10:36:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Greg KH <gregkh@suse.de>
Cc: Hans-Peter Jansen <hpj@urpla.net>, xfs@oss.sgi.com,
       opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100426003637.GB11437@dastard>
References: <201004050049.17952.hpj@urpla.net>
 <20100413091823.GD7544@dastard>
 <201004131142.33518.hpj@urpla.net>
 <201004241844.23482.hpj@urpla.net>
 <20100425162740.GB19195@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100425162740.GB19195@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > FYI, 2.6.33.2 is still affected from this issue. 
> 
> Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> 2.6.32.12-rc2.)

The fix is not in Linus' kernel yet, Greg. So once that is done,
I'll have to backport the fix back to those stable kernels as well.
It's not a trivial fix, so it will miss this round of stable
releases....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
