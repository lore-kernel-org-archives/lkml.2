Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1AaAsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 19:48:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:42848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1AaAsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 19:48:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,402,1291622400"; 
   d="scan'208";a="597894957"
Date: Mon, 31 Jan 2011 01:48:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Staticise non-exported symbols in MAX8998 driver
Message-ID: <20110131004850.GH2565@sortiz-mobl>
References: <1295560051-4054-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295560051-4054-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jan 20, 2011 at 09:47:31PM +0000, Mark Brown wrote:
> No need to have them in the global namespace and sparse complains.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
