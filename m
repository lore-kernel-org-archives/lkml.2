Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1ISJkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:40:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:3249 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1ISJkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,404,1312182000"; 
   d="scan'208";a="55210461"
Date: Mon, 19 Sep 2011 11:43:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?=22Uwe_Kleine-K=F6nig=22?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20110919094323.GQ32263@sortiz-mobl>
References: <20110919161900.99b51989c9a02075e9f4cc93@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919161900.99b51989c9a02075e9f4cc93@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 19, 2011 at 04:19:00PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
Sorry. I pushed a fix for this. allmodconfig should be clean now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
