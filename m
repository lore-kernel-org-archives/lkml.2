Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2BOR7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:59:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:33381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab2BOR7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:59:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117892588"
Subject: Re: [PATCH] iwlwifi: iwl-agn.h included twice
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: linux-wireless@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1329328516-4792-1-git-send-email-danny.kukawka@bisect.de>
References: <1329328516-4792-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 08:50:09 -0800
Message-ID: <1329324609.7290.67.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 18:55 +0100, Danny Kukawka wrote:
> drivers/net/wireless/iwlwifi/iwl-core.c included 'iwl-agn.h' twice,
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

