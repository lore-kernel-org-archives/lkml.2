Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1BYBZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:25:40 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:36987 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096Ab1BYBZj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:25:39 -0500
From: Philip Rakity <prakity@marvell.com>
To: Chris Ball <cjb@laptop.org>
CC: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 24 Feb 2011 17:25:26 -0800
Subject: Re: [PATCH 1/1]mmc: set timeout for SDHCI host before sending busy
	cmd
Thread-Topic: [PATCH 1/1]mmc: set timeout for SDHCI host before sending busy
	cmd
Thread-Index: AcvUiuJNACx/gxETSDC0n2ivBD15QA==
Message-ID: <8C92BC0B-B9F7-4D48-AD24-6096F92D6998@marvell.com>
References: <20110224111935.GB7169@intel.com>
 <AANLkTinJEXc_x36Rht=XfYEtjShAYKWRDcsjGFtd=5Tj@mail.gmail.com>
 <5D8008F58939784290FAB48F5497519835CE59FE81@shsmsx502.ccr.corp.intel.com>
 <79DD18D4-C79A-4B08-B9E6-050D7EF2FC3D@marvell.com>
 <20110224201504.GA12913@void.printf.net>
In-Reply-To: <20110224201504.GA12913@void.printf.net>
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


On Feb 24, 2011, at 12:15 PM, Chris Ball wrote:

> On Thu, Feb 24, 2011 at 10:32:30AM -0800, Philip Rakity wrote:
>> proposed this a while ago and strongly support just removing the quirk for broken timeout and setting the timeout value to maximum of 0xE.
>> 
>> This also handles the case of the sd device having a timeout value too low.  In my testing I have come across SD cards that do not provide the correct value.
>> We force our pxa168, pxa910, and mmp2 controllers to have 0xE.  
> 
> Yeah, OLPC's CaFe controller -- which might be the same hardware as yours,
> actually -- has the same problem.

different controller not same as on mmp2, pxa168, pxa910

> 
> Does anyone know of a reason (beyond strict spec-compliance, I suppose)
> for honoring the timeout value rather than using 0xE everywhere?  If not,
> I'm willing to try out Philip's suggestion.
> 
> Thanks,
> 
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child

