Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1IRRMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:12:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:36307 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab1IRRMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,401,1312182000"; 
   d="scan'208";a="50138156"
Date: Sun, 18 Sep 2011 19:15:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20110918171515.GN32263@sortiz-mobl>
References: <20110916135523.01ec57f699192230272e99e3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916135523.01ec57f699192230272e99e3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Sep 16, 2011 at 01:55:23PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/leds/leds-mc13783.c: In function 'mc13783_leds_prepare':
> drivers/leds/leds-mc13783.c:193:11: error: dereferencing pointer to incomplete type
>

This should be fixed now, thanks for the report.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
