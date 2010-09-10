Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0IJPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:41:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:22943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab0IJPlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,347,1280732400"; 
   d="scan'208";a="323200415"
Date: Fri, 10 Sep 2010 17:41:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: mfd: tps6586x - free allocated resources when unload the module
Message-ID: <20100910154154.GJ2561@sortiz-mobl>
References: <1282534380.2281.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282534380.2281.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Aug 23, 2010 at 11:33:00AM +0800, Axel Lin wrote:
> For the resources allocated in tps6586x_i2c_probe(),
> we need to free it in tps6586x_i2c_remove().
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
