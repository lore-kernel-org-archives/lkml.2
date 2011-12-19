Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1LSKwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:52:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:47519 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab1LSKwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:52:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89004367"
Date: Mon, 19 Dec 2011 11:57:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tc6393xb - add depend on HAVE_CLK
Message-ID: <20111219105714.GY11800@sortiz-mobl>
References: <1322591918.2182.35.camel@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322591918.2182.35.camel@mars>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chrisptoph,

On Tue, Nov 29, 2011 at 07:38:38PM +0100, Christoph Fritz wrote:
> This patch adds HAVE_CLK to the required dependencies of tc6393xb.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
