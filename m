Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2DPQnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:43:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:27528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab2DPQnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142370775"
Date: Mon, 16 Apr 2012 18:50:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pasi Savanainen <ext-pasi.m.savanainen@nokia.com>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] mfd: Convert Intel MSIC driver to use devm_* interfaces.
Message-ID: <20120416165054.GQ24130@sortiz-mobl>
References: <1334223637-16965-1-git-send-email-ext-pasi.m.savanainen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334223637-16965-1-git-send-email-ext-pasi.m.savanainen@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pasi,

On Thu, Apr 12, 2012 at 12:40:37PM +0300, Pasi Savanainen wrote:
> The devm_* functions eliminate the need for manual resource releasing
> and simplify error handling. Resources allocated by devm_* are freed
> automatically on driver detach.
> 
> Signed-off-by: Pasi Savanainen <ext-pasi.m.savanainen@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/mfd/intel_msic.c |   31 +++++--------------------------
>  1 files changed, 5 insertions(+), 26 deletions(-)
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
