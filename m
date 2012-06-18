Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2FRHwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:52:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:56512 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2FRHwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166855014"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] max17042_battery: Support CHARGE_COUNTER power supply
 attribute
Thread-Topic: [PATCH] max17042_battery: Support CHARGE_COUNTER power supply
 attribute
Thread-Index: AQHNLBntbxd1TfR3qUyWQWXE4O9iP5b/9dtQ
Date: Mon, 18 Jun 2012 07:52:02 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD16A752@BGSMSX102.gar.corp.intel.com>
References: <1336366558-27137-1-git-send-email-ramakrishna.pallala@intel.com>
In-Reply-To: <1336366558-27137-1-git-send-email-ramakrishna.pallala@intel.com>
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

> Sent: Monday, May 07, 2012 10:26 AM
> To: linux-kernel@vger.kernel.org
> Cc: Anton Vorontsov; Anton Vorontsov; Pallala, Ramakrishna
> Subject: [PATCH] max17042_battery: Support CHARGE_COUNTER power supply
> attribute
> 
> This patch adds the support for CHARGE_COUNTER power supply attribute to
> max17042/47 driver.
> 
> Note:QH(Charge Counter) register is not documented in max17042 the Spec.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  drivers/power/max17042_battery.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 

I am waiting for the comments or ACK from you on this patch.

Thanks,
Ram

