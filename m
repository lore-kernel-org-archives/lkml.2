Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1HELx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 07:53:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17354 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1HELx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 07:53:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Aug 2011 04:53:25 -0700
From: Danny Huang <dahuang@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "mike@compulab.co.il" <mike@compulab.co.il>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Xin Xie <xxie@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Aug 2011 19:53:20 +0800
Subject: RE: [PATCH] regulator: tps6586x: add SMx slew rate setting
Thread-Topic: [PATCH] regulator: tps6586x: add SMx slew rate setting
Thread-Index: AcxSo/0hwQUm5e86R8CBVZCrZjAsLAAus7xQ
Message-ID: <1BA5D2DFD2730747A2B3725B59933B93C07A47561D@HKMAIL01.nvidia.com>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
 <20110804124220.GA14921@sirena.org.uk>
In-Reply-To: <20110804124220.GA14921@sirena.org.uk>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I'll implement this in a separate patch.

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Thursday, August 04, 2011 20:42
To: Danny Huang
Cc: lrg@ti.com; mike@compulab.co.il; sameo@linux.intel.com; Xin Xie; gking@nvidia.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting

On Thu, Aug 04, 2011 at 07:34:22PM +0800, dahuang@nvidia.com wrote:
> From: Danny Huang <dahuang@nvidia.com>
> 
> Add output vlotage slew rate setting for SM0/SM1

Oh, and you should also be implementing set_voltage_time_sel() if you know what the slew rate for the device is.
