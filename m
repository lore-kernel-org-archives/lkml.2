Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0JVKao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:30:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:35400 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0JVKan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:30:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,222,1286175600"; 
   d="scan'208";a="669816464"
Date: Fri, 22 Oct 2010 12:30:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] mfd: Remove unneeded ret value checking
Message-ID: <20101022103039.GC2570@sortiz-mobl>
References: <1287707426.27802.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287707426.27802.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, Oct 22, 2010 at 08:30:26AM +0800, Axel Lin wrote:
> i2c_smbus_write_byte_data() returns zero or negative value,
> therefore no need to check if ret is greater than zero or not.
All 3 (including the mc13xx one) patches applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
