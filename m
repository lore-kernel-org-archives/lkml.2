Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1HZFsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:48:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:27032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1HZFsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,283,1312182000"; 
   d="scan'208";a="42623751"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Date: Fri, 26 Aug 2011 11:16:53 +0530
Subject: [Power-supply]: Error handling in max17042_battery.c
Thread-Topic: [Power-supply]: Error handling in max17042_battery.c
Thread-Index: Acxjs47fEM7dlp1iSkeRZO6cUh7CdQ==
Message-ID: <12D0C12AF19E15409D57F22566E88EF5097576EBFB@bgsmsx501.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: ADu7 FbHj HhCF Lj7P M61x PCQM PUHc SS1h Uhcr V+9y bMo0
 cWHn c75x eTEa hgSz
 olke;4;YwBiAG8AdQBhAHQAbQBhAGkAbAByAHUAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQB5AHUAbgBnAGoAbwBvAC4AaABhAG0AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0A;Sosha1_v1;7;{25D2DF74-1DFF-459F-8A80-3D4E5F9F6CC7};cgBhAG0AYQBrAHIAaQBzAGgAbgBhAC4AcABhAGwAbABhAGwAYQBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Fri,
 26 Aug 2011 05:46:53
 GMT;WwBQAG8AdwBlAHIALQBzAHUAcABwAGwAeQBdADoAIABFAHIAcgBvAHIAIABoAGEAbgBkAGwAaQBuAGcAIABpAG4AIABtAGEAeAAxADcAMAA0ADIAXwBiAGEAdAB0AGUAcgB5AC4AYwA=
x-cr-puzzleid: {25D2DF74-1DFF-459F-8A80-3D4E5F9F6CC7}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am working on the I2C based max17042 fuel gauge driver
Which is drivers/power/max17042_battery.c

In max17042_get_property(...), the values returned by
Max17042_read_reg are directly assigned to the variables,
even if the read results in an error. Shouldn't we check
for the 'correctness' of the returned values and then
assign them ? Can I submit a patch to change this ?

Or Is this done intentionally ?

Thanks,
Ram



