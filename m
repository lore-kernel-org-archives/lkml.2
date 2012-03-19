Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab2CSIih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:38:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5041 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2CSIif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:38:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Mar 2012 01:38:35 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Mar 2012 14:08:31 +0530
Subject: RE: [PATCH] mfd: Add support for TPS65090
Thread-Topic: [PATCH] mfd: Add support for TPS65090
Thread-Index: Ac0Ds+aSHxVHwvWKS/OBOKnYIqu5FQB9rxeQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127A5B@BGMAIL02.nvidia.com>
References: <1331876419-10478-1-git-send-email-vbyravarasu@nvidia.com>
 <20120316204015.GW20524@sortiz-mobl>
In-Reply-To: <20120316204015.GW20524@sortiz-mobl>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Thanks for your prompt reply.

> The patch looks good. Could you please provide me with a better description
> for this device (sub devices, etc...) ?

TPS65090 is a PMIC offered by TI. It contains:
	a. 3 Step-Down Converters:
	b. 2 Always On LDO's
	c. 7 Current Limited Load Switches

With this patch adding basic PMIC functionality along with interrupt controller support.
Once this patch gets merged, will add regulator driver for this device.

Thanks,
Venu
