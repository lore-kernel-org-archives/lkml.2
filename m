Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671Ab2CPQVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:21:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:39708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326Ab2CPQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140008166"
Date: Fri, 16 Mar 2012 17:29:29 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        arnd@arndb.de
Subject: Re: [PATCH 01/03] MFD: add ADC support to DA9052/53 MFD  core v2
Message-ID: <20120316162929.GB20524@sortiz-mobl>
References: <1330698533.21817.30.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330698533.21817.30.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, Mar 02, 2012 at 07:58:53PM +0530, Ashish Jangam wrote:
> This patch add ADC support for DA9052/53 MFD core so that its dependent
> components like Battery & HWMON can read required values from ADC
> channel.
> 
> This patch is functionally tested on Samsung SMDKV6410.
Could you please fix your patch according to Arnd's comments ? After that I'll
apply it to my mfd tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
