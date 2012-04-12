Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2DLKMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:12:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:62296 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab2DLKMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:12:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="130020148"
Date: Thu, 12 Apr 2012 13:14:04 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Pasi Savanainen <ext-pasi.m.savanainen@nokia.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Convert Intel MSIC driver to use devm_* interfaces.
Message-ID: <20120412101404.GD2258@intel.com>
References: <1334223637-16965-1-git-send-email-ext-pasi.m.savanainen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334223637-16965-1-git-send-email-ext-pasi.m.savanainen@nokia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:40:37PM +0300, Pasi Savanainen wrote:
> The devm_* functions eliminate the need for manual resource releasing
> and simplify error handling. Resources allocated by devm_* are freed
> automatically on driver detach.
> 
> Signed-off-by: Pasi Savanainen <ext-pasi.m.savanainen@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Looks good to me.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
