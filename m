Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1KMX6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:58:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:41629 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab1KMX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:58:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,503,1315206000"; 
   d="scan'208";a="36652926"
Date: Mon, 14 Nov 2011 01:02:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH] mfd: adp5520: Ensure setting bits if new value is
 different from the old value
Message-ID: <20111114000250.GC22218@sortiz-mobl>
References: <1320030006.2690.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320030006.2690.8.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Oct 31, 2011 at 11:00:06AM +0800, Axel Lin wrote:
> Current code checks if all the bit_mask bits are all zero is wrong.
> We need to write new value if the bit mask fields of new value is
> not equal to old value.
I applied all 3 patches, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
