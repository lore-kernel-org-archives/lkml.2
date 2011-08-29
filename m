Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1H2FhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:37:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:44330 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab1H2FhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:37:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,295,1312182000"; 
   d="scan'208";a="11986500"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Date: Mon, 29 Aug 2011 11:00:07 +0530
Subject: RE: [Power-supply]: Error handling in max17042_battery.c
Thread-Topic: [Power-supply]: Error handling in max17042_battery.c
Thread-Index: Acxjs47fEM7dlp1iSkeRZO6cUh7CdQCWL64w
Message-ID: <12D0C12AF19E15409D57F22566E88EF5097576F280@bgsmsx501.gar.corp.intel.com>
References: <12D0C12AF19E15409D57F22566E88EF5097576EBFB@bgsmsx501.gar.corp.intel.com>
In-Reply-To: <12D0C12AF19E15409D57F22566E88EF5097576EBFB@bgsmsx501.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi All,
> 
> I am working on the I2C based max17042 fuel gauge driver
> Which is drivers/power/max17042_battery.c
> 
> In max17042_get_property(...), the values returned by
> Max17042_read_reg are directly assigned to the variables,
> even if the read results in an error. Shouldn't we check
> for the 'correctness' of the returned values and then
> assign them ? Can I submit a patch to change this ?
> 
> Or Is this done intentionally ?

Any inputs on this?

Thanks,
Ram
