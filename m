Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2JBJfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:35:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:7823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2JBJfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:35:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,522,1344236400"; 
   d="scan'208";a="229454544"
Date: Tue, 2 Oct 2012 11:35:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the mfd tree
Message-ID: <20121002093519.GI12231@sortiz-mobl>
References: <20120912134349.f1dd0f4d050dd4834623e57b@canb.auug.org.au>
 <alpine.LNX.2.00.1210020018340.23544@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210020018340.23544@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Oct 02, 2012 at 12:21:16AM +0200, Jiri Kosina wrote:
> On Wed, 12 Sep 2012, Stephen Rothwell wrote:
> 
> > Hi Jiri,
> > 
> > Today's linux-next merge of the trivial tree got a conflict in
> > drivers/video/backlight/88pm860x_bl.c between commit a6ccdcd98c39 ("mfd:
> > 88pm860x: Use REG resource for backlight") from the mfd tree and commit
> > e1c9ac420ef1 ("Revert "backlight: fix memory leak on obscure error
> > path"") from the trivial tree.
> > 
> > I just used the version from the mfd tree and can carry the fix as
> > necessary (no action is required).
> 
> Samuel,
> 
> Linus has just pulled from trivial.git, so could you please make sure this 
> is taken care of (*) in your next pull request? Thanks a lot!
> 
> (*) either by resolving the conflict in your tree first, or mentioning it 
> explicitly in your pull request to Linus.
Thanks for the heads up.
I usually fix the merge conflicts in a specific branch for-next-merge and
give the URL to Linus, in case he needs it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
