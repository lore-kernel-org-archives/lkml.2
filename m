Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0LINxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:53:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:33992 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0LINxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:53:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="582114011"
Date: Thu, 9 Dec 2010 14:52:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        stable@kernel.org
Subject: Re: [PATCH] mfd: Support additional parent IDs for wm831x
Message-ID: <20101209135242.GJ8884@sortiz-mobl>
References: <1291307143-8472-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291307143-8472-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Dec 02, 2010 at 04:25:43PM +0000, Mark Brown wrote:
> Some newer device revisions add a second parent ID. Support this in
> the device validity checks done at startup.
Patch applied to both my for-next and for-linus branches, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
