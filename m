Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1JTQo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:44:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:55063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1JTQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="65180090"
Date: Thu, 20 Oct 2011 18:47:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, mrst: add platform support for MSIC MFD driver
Message-ID: <20111020164743.GA3871@sortiz-mobl>
References: <20111018091311.GD7694@sortiz-mobl>
 <1318930882-10017-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318930882-10017-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Tue, Oct 18, 2011 at 12:41:22PM +0300, Mika Westerberg wrote:
> The MSIC MFD driver creates platform devices for MSIC device drivers so we
> don't need to create them in platform code anymore.
> 
> This patch adds a new runtime check which determines whether we are running
> on a Medfield platform and enables the MSIC MFD driver accordingly.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
I applied this new version, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
