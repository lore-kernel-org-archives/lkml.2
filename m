Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2LFBRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:17:23 -0500
Received: from atl4mhob15.myregisteredsite.com ([209.17.115.53]:57294 "EHLO
	atl4mhob15.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab2LFBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:17:22 -0500
X-Greylist: delayed 1963 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 20:17:22 EST
Subject: Re: [patch] propagate name change to comments in kernel source
From: Nadia Yvette Chambers <nyc@holomorphy.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20121206120148.99919a3512c72947c8baba67@canb.auug.org.au>
References: <1354754668.9720.198.camel@tisifone>
	 <20121206120148.99919a3512c72947c8baba67@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Dec 2012 20:17:14 -0500
Message-ID: <1354756634.9720.203.camel@tisifone>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 12:01 +1100, Stephen Rothwell wrote:
> OK, that may be a problem.  Does this patch apply to Linus' tree
> currently?  I guess not.  So, either you need to split it up and send it
> to the various maintainers (most if it can probably go through the trivial
> tree (cc'd)).  Or wait until after v3.8-rc1 and fix it so it applies to
> Linus' tree and send it to him.
> Or Andrew (cc'd) may be able to take it (as his tree is based on
> linux-next currently).
> (I have attached the patch for Jiri's and Andrew's benefit)

It applies with offsets to Linus' current git, actually. I can provide a
diff applying with no offsets, but suspect it's unnecessary. The
affected comment blocks don't seem to have experienced much turnover
recently, if ever.

-- nyc


