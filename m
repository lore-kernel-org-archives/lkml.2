Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540Ab2CUUcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:32:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:58627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760155Ab2CUUct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:32:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131666671"
Date: Wed, 21 Mar 2012 21:40:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Donggeun Kim <dg77.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd and
 input trees related)
Message-ID: <20120321204055.GC3875@sortiz-mobl>
References: <20120321182930.6f75199b7406044669891a14@canb.auug.org.au>
 <20120321080313.GA12410@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321080313.GA12410@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, Stephen,

On Wed, Mar 21, 2012 at 01:03:13AM -0700, Dmitry Torokhov wrote:
> > Caused by a bad merge of commits 104594b01ce7 ("Input: add driver support
> > for MAX8997-haptic") from the input tree and 02b09703e7a4 ("mfd: Add
> > platform data for MAX8997 haptic driver") from the mfd tree.
> 
> Sorry about this. I thought Samuel was going to revert the platform data
> from his tree as he OKed applying the combined patch...
My fault indeed. The commit is reverted now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
