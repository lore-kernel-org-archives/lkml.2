Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2FTJ7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:59:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:60941 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2FTJ7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114140736"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: [PATCH] power_supply: Add charge_rate_limit power supply
 attribute
Thread-Topic: [PATCH] power_supply: Add charge_rate_limit power supply
 attribute
Thread-Index: AQHNTsexFTHUZuKV40Sutu/ZKYINbJcC+QuQ
Date: Wed, 20 Jun 2012 09:59:46 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD16CF56@BGSMSX102.gar.corp.intel.com>
References: <1340179683-6548-1-git-send-email-ramakrishna.pallala@intel.com>
In-Reply-To: <1340179683-6548-1-git-send-email-ramakrishna.pallala@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sent: Wednesday, June 20, 2012 1:38 PM
> To: linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; Anton Vorontsov; Pallala, Ramakrishna
> Subject: [PATCH] power_supply: Add charge_rate_limit power supply attribute
> 
> During charging battery temperature and charger chip(die) temperature will go
> up and this intern adds upto the overall platform temperature.
> On mobile devices this can have huge impact on the user(user experience).
> 
> This patch adds a new power supply property charge_rate_limit which can be
> used by user space app/framework(Ex: Thermal Manager) to control the overall
> platform temperature by changing the charge rate property.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  Documentation/power/power_supply_class.txt |    4 ++++
>  drivers/power/power_supply_sysfs.c         |    1 +
>  include/linux/power_supply.h               |    8 ++++++++
>  3 files changed, 13 insertions(+), 0 deletions(-)

Please ignore this patch.

Thanks,
Ram
