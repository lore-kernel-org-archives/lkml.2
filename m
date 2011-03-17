Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1CQXsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:48:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:5707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1CQXr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="404393939"
Date: Fri, 18 Mar 2011 00:47:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Staticise WM8994 PM ops
Message-ID: <20110317234755.GE32172@sortiz-mobl>
References: <1300379629-8434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300379629-8434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Mar 17, 2011 at 04:33:49PM +0000, Mark Brown wrote:
> They're not exported.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
