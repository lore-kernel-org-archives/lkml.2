Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0C2CAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:00:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:25096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0C2CAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,325,1267430400"; 
   d="scan'208";a="504430501"
Subject: Re: [patch] iwlwifi: range checking issue
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
       "Berg, Johannes" <johannes.berg@intel.com>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20100328115500.GX5069@bicker>
References: <20100328115500.GX5069@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 10:01:12 +0800
Message-ID: <1269828072.4043.247.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 19:55 +0800, Dan Carpenter wrote:
> IWL_RATE_COUNT is 13 and IWL_RATE_COUNT_LEGACY is 12.
> 
> IWL_RATE_COUNT_LEGACY is the right one here because iwl3945_rates
> doesn't support 60M and also that's how "rates" is defined in
> iwlcore_init_geos() from drivers/net/wireless/iwlwifi/iwl-core.c.
> 
>         rates = kzalloc((sizeof(struct ieee80211_rate) * IWL_RATE_COUNT_LEGACY),
>                         GFP_KERNEL);
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

