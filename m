Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2KWLDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:03:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:60859 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab2KWLDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:03:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="246155330"
Date: Fri, 23 Nov 2012 12:03:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org
Subject: Re: [PATCH V2 1/2] mfd: stmpe: Use devm_*() routines
Message-ID: <20121123110313.GA12685@sortiz-mobl>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Nov 22, 2012 at 10:40:29AM +0530, Viresh Kumar wrote:
> This patch frees stmpe driver from tension of freeing resources :)
> devm_* derivatives of multiple routines are used while allocating resources,
> which would be freed automatically by kernel.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Applied, with Lee's Ack.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
