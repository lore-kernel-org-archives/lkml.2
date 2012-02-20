Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2BTLhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:37:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:35309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2BTLhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:37:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68314753"
Date: Mon, 20 Feb 2012 12:44:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        arnd@arndb.de
Subject: Re: [PATCH 01/01] MFD: add ADC support to DA9052/53 MFD  core v2
Message-ID: <20120220114420.GT5387@sortiz-mobl>
References: <1326465051.3542.334.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326465051.3542.334.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, Jan 13, 2012 at 08:00:51PM +0530, Ashish Jangam wrote:
> +struct completion done;
This shouldn't be a global variable, but a struct da9052 one instead.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
