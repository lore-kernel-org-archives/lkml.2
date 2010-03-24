Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab0CXUS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:18:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:47696 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0CXUSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,302,1267430400"; 
   d="scan'208";a="551816705"
Subject: Re: [PATCH 4/7] wireless/iwlwifi: remove trailing space in messages
From: reinette chatre <reinette.chatre@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>
In-Reply-To: <1269456395-15343-4-git-send-email-elendil@planet.nl>
References: <201003241927.12434.elendil@planet.nl>
	 <1269456395-15343-4-git-send-email-elendil@planet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 13:18:53 -0700
Message-ID: <1269461933.2446.3208.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

On Wed, 2010-03-24 at 11:46 -0700, Frans Pop wrote:
> Includes minor improvements in debugging messages in iwl-4965.c,
> function iwl4965_is_temp_calib_needed().
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: Intel Linux Wireless <ilw@linux.intel.com>
> 
> wireless/intel

Since this patch touches so many things, would it be possible to base
your patch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
instead? We currently have some code reorganization pending there that
is undergoing validation before we push it upstream. If you do so you
can send the patch to me indicating so and I will push it upstream as
part of our process to ensure there are no conflicts ahead.

Thank you

Reinette


