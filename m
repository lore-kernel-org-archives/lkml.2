Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2ISHf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:35:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:32629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab2ISHf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="207668912"
Date: Wed, 19 Sep 2012 10:37:34 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Message-ID: <20120919073734.GO15548@intel.com>
References: <1347985687-22676-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347985687-22676-1-git-send-email-ramakrishna.pallala@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 09:58:07PM +0530, Ramakrishna Pallala wrote:
> This patch checks for charger status register for determining the
> battery charging status and reports Discharing/Charging/Not Charging/Full
> accordingly.
> 
> This patch also adds the interrupt support for Safety Timer Expiration.
> This interrupt is helpful in debugging the cause for charger fault.
> 
> Resending this patch because previous patch missed Anton's attention
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
