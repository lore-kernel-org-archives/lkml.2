Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1LLOcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:32:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:32227 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab1LLOct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:32:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="86278941"
Date: Mon, 12 Dec 2011 15:37:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] mfd: Add basic device tree binding for wm8994
Message-ID: <20111212143748.GH13952@sortiz-mobl>
References: <1321988368-16121-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321988368-16121-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Nov 22, 2011 at 06:59:28PM +0000, Mark Brown wrote:
> Add a placeholder device tree binding for the wm8994 driver. At present
> the binding is essentially null as none of the platform data is supported,
> and at least some of that will depend on the pending regulator bindings.
I applied this one to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
