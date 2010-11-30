Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0K3KCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:02:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:65295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab0K3KCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:02:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,279,1288594800"; 
   d="scan'208";a="862644567"
Date: Tue, 30 Nov 2010 11:02:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: Re: linux-next: build warning after merge of the mfd tree
Message-ID: <20101130100239.GB11125@sortiz-mobl>
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Nov 29, 2010 at 11:52:57AM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/mfd/cs5535-mfd.c: In function 'cs5535_mfd_probe':
> drivers/mfd/cs5535-mfd.c:106: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> 
> Introduced by commit a0d4503a044e67ac46adfe8f42eddefd2b60f85e ("mfd: Add
> cs5535-mfd driver for AMD Geode's CS5535/CS5536 support").
That should be fixed by now, thanks for the report.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
