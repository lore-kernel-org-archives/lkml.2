Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2FRGDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:03:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:51186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2FRGDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:03:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="158852512"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
CC: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
Subject: RE: [PATCH 4/5] intel_mid_thermal: Use struct dev_pm_ops for power
 management
Thread-Topic: [PATCH 4/5] intel_mid_thermal: Use struct dev_pm_ops for power
 management
Thread-Index: AQHNTMei8caaDTWFsEa52YFDpV0N0Zb/lguQ
Date: Mon, 18 Jun 2012 06:03:16 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59143300@BGSMSX101.gar.corp.intel.com>
References: <201206172226.42729.rjw@sisk.pl> <201206172229.41550.rjw@sisk.pl>
In-Reply-To: <201206172229.41550.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5I63SxQ018875

Thanks Rafael for the patch.

> -----Original Message-----
> From: platform-driver-x86-owner@vger.kernel.org [mailto:platform-driver-x86-
> owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Monday, June 18, 2012 2:00 AM
> To: platform-driver-x86@vger.kernel.org
> Cc: Henrique de Moraes Holschuh; LKML; Linux PM list; Matthew Garrett; Joey
> Lee
> Subject: [PATCH 4/5] intel_mid_thermal: Use struct dev_pm_ops for power
> management
> 
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the intel_mid_thermal driver define its PM callbacks through
> a struct dev_pm_ops object rather than by using legacy PM hooks
> in struct platform_driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Reviewed-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
