Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2HWG1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:27:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:43155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2HWG1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:27:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,298,1344236400"; 
   d="scan'208";a="137012599"
Date: Thu, 23 Aug 2012 09:30:05 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Message-ID: <20120823063005.GL15548@intel.com>
References: <1345686558-16512-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345686558-16512-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:19:18AM +0530, Ramakrishna Pallala wrote:
> This patch checks for charger status register for determining the
> battery charging status and reports Discharing/Charging/Not Charging/Full
> accordingly.
> 
> This patch also adds the interrupt support for Safety Timer Expiration.
> This interrupt is helpful in debugging the cause for charger fault.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
