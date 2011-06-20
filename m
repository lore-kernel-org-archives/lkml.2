Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1FTO5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:57:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:43888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1FTO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:57:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="15932482"
Date: Mon, 20 Jun 2011 16:57:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Ensure value written by wm831x_set_bits() is within
 the mask
Message-ID: <20110620145706.GP22420@sortiz-mobl>
References: <1308569158-22484-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308569158-22484-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jun 20, 2011 at 12:25:58PM +0100, Mark Brown wrote:
> Purely for defensiveness.
Ok, applied too.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
