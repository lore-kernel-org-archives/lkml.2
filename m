Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1AaKwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:52:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:23618 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1AaKwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:52:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,403,1291622400"; 
   d="scan'208";a="598013254"
Date: Mon, 31 Jan 2011 11:52:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/4 v4] video, sm501: add OF binding to support SM501
Message-ID: <20110131105239.GE5954@sortiz-mobl>
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1295863058-11168-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295863058-11168-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Mon, Jan 24, 2011 at 10:57:38AM +0100, Heiko Schocher wrote:
> - add binding to OF, compatible name "smi,sm501"
The MFD part looks fine to me:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
