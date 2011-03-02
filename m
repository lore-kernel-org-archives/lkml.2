Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1CBLui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:50:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:58852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab1CBLug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:50:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="892948958"
Date: Wed, 2 Mar 2011 12:50:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core switch off status added
Message-ID: <20110302115031.GJ16181@sortiz-mobl>
References: <1299063156-31972-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299063156-31972-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Wed, Mar 02, 2011 at 11:52:36AM +0100, Mattias Wallin wrote:
> This patch adds a sysfs file with the ab8500 switch off status.
> The switch off status contains information of what caused the ab8500
> chip to power off. A print during boot is also added.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
