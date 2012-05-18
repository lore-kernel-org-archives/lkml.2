Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960Ab2ERK3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:29:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:13186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161056Ab2ERK1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168040678"
Date: Fri, 18 May 2012 12:37:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lm3533: convert to use devres
Message-ID: <20120518103704.GJ12015@sortiz-mobl>
References: <1337102693-30911-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337102693-30911-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Tue, May 15, 2012 at 07:24:53PM +0200, Johan Hovold wrote:
> Use devres to manage core driver data and regmap.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
