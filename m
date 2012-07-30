Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2G3Erv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 00:47:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:38744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab2G3Eru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 00:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="179158545"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Devendra Naga <develkernel412222@gmail.com>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] lp8727_charger: unregister power supply at error
 path of lp8727_register_psy
Thread-Topic: [PATCH 2/2] lp8727_charger: unregister power supply at error
 path of lp8727_register_psy
Thread-Index: AQHNbbJH5Up592d5yUufZRjIeb6zzpdBQMOQ
Date: Mon, 30 Jul 2012 04:47:44 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD1C5372@BGSMSX102.gar.corp.intel.com>
References: <1343584015-30344-1-git-send-email-develkernel412222@gmail.com>
In-Reply-To: <1343584015-30344-1-git-send-email-develkernel412222@gmail.com>
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

>  	if (power_supply_register(pchg->dev, &psy->usb))
> -		goto err_psy;
> +		goto err_psy_ac;

"err_psy_ac" label name is confusing. Why can't you use err_psy_usb

>  	if (power_supply_register(pchg->dev, &psy->batt))
> -		goto err_psy;
> +		goto err_psy_usb;

Same here, why don't you use err_psy_batt

Thanks,
Ram
