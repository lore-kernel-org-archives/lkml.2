Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1HVJDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:03:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:19065 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1HVJDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,262,1312182000"; 
   d="scan'208";a="9689751"
Date: Mon, 22 Aug 2011 11:05:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/3] Add regmap support for WM831x and WM8994
Message-ID: <20110822090510.GE4607@sortiz-mobl>
References: <20110806035806.GA21557@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806035806.GA21557@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Aug 06, 2011 at 12:58:08PM +0900, Mark Brown wrote:
> This series converts the WM831x and WM8994 MFD drivers over to using the
> regmap API (which was merged by Linus during this merge window).  As
> these are my main devices for use when developing regmap it would be
> very helpful if I could merge them via the regmap tree - does that seem
> sensible to you?
Definitely, yes. Please add my:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
