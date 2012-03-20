Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab2CTPcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:32:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:46583 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab2CTPb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:31:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141938778"
Date: Tue, 20 Mar 2012 16:39:22 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: da9052-i2c - add some section annotations
Message-ID: <20120320153922.GB17818@sortiz-mobl>
References: <20120317230108.GA19068@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120317230108.GA19068@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sat, Mar 17, 2012 at 04:01:09PM -0700, Dmitry Torokhov wrote:
> da9052_i2c_remove() can and should be marked as __devexit.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
