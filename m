Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2FRHuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:50:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:32953 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab2FRHuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:50:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166854606"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] power_supply: Add charge_current and charge_voltage
 properties and use it in smb347
Thread-Topic: [PATCH] power_supply: Add charge_current and charge_voltage
 properties and use it in smb347
Thread-Index: AQHNK5KTQVLm+41FKUC3WmtvNurJNJb/9j1A
Date: Mon, 18 Jun 2012 07:50:18 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD16A73C@BGSMSX102.gar.corp.intel.com>
References: <1336308404-25129-1-git-send-email-ramakrishna.pallala@intel.com>
In-Reply-To: <1336308404-25129-1-git-send-email-ramakrishna.pallala@intel.com>
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

Hi Anton,

> Sent: Sunday, May 06, 2012 6:17 PM
> To: linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; Anton Vorontsov; Mika Westerberg; Pallala, Ramakrishna
> Subject: [PATCH] power_supply: Add charge_current and charge_voltage
> properties and use it in smb347
> 
> Constant Charge Current(CC) is charging parameter which limit the maximum
> current which can be pumped into the battery during charge cycle.
> 
> Constant Charge Voltage(CV) is also charging parameter which limit the
> maximum voltage that battery can reach during charge cycle.
> 
> It is very common practice that at low or high temperatures we do not charge
> the batteries upto it's fullest charge voltage to avoid battery and user safety
> issues.
> 
> These sysfs properties will be useful for debug and to implement certain user
> space policies like "Charging limited due to OverTemp".
> 
> This patch also makes use of these two properties in smb347 charger driver.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  Documentation/power/power_supply_class.txt |    4 +
>  drivers/power/power_supply_sysfs.c         |    2 +
>  drivers/power/smb347-charger.c             |  123 ++++++++++++++++++++++++++-
> -
>  include/linux/power_supply.h               |    4 +
>  4 files changed, 127 insertions(+), 6 deletions(-)
> 

I didn't receive any comment on this patch yet.
Can I assume it is in your merge queue?

Thanks,
Ram

