Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0IJRAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:00:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:55818 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0IJRAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:00:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,347,1280732400"; 
   d="scan'208";a="323232481"
Date: Fri, 10 Sep 2010 19:00:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Cc: w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH] stmpe-gpio: Handle platform data with no gpio base
Message-ID: <20100910170021.GP2561@sortiz-mobl>
References: <1283229296-16733-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283229296-16733-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:04:56AM +0530, Virupax Sadashivpetimath wrote:
> This patch removes the requirement that gpio base be supplied in
> platform data.
Patch applied to my for-next branch, unless David wants to take it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
