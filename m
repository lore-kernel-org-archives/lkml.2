Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2ETNK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:10:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:57918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab2ETNKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:10:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="146092071"
Date: Sun, 20 May 2012 15:20:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: Mark two lm3533 zone registers as volatile
Message-ID: <20120520132023.GW12015@sortiz-mobl>
References: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
 <1337365366-14385-2-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337365366-14385-2-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Fri, May 18, 2012 at 08:22:46PM +0200, Johan Hovold wrote:
> Mark the two currently unused zone registers as volatile in regmap for
> completeness.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
