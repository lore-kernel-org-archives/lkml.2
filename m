Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800Ab2GMFyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:54:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:56857 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030184Ab2GMFyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:54:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192088588"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Alex Courbot <acourbot@nvidia.com>
CC: Wei Ni <wni@nvidia.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>
Subject: RE: How to use the generic thermal sysfs.
Thread-Topic: How to use the generic thermal sysfs.
Thread-Index: AQHNYBhwfglBqKFiaEq9VEEbCoJV25cld52QgADiU4CAAFyesA==
Date: Fri, 13 Jul 2012 05:54:26 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5915392A@BGSMSX101.gar.corp.intel.com>
References: <1342088573.27605.101.camel@tegra-chromium-2>
 <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
 <4FFFB6BD.903@nvidia.com>
In-Reply-To: <4FFFB6BD.903@nvidia.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6D5sodq013009

> -----Original Message-----
> From: Alex Courbot [mailto:acourbot@nvidia.com]
> Sent: Friday, July 13, 2012 11:19 AM
> To: R, Durgadoss
> Cc: Wei Ni; Zhang, Rui; Brown, Len; akpm@linux-foundation.org; khali@linux-
> fr.org; joe@perches.com; linux-kernel@vger.kernel.org; linux-
> tegra@ger.kernel.org
> Subject: Re: How to use the generic thermal sysfs.
> 
> On 07/12/2012 07:54 PM, R, Durgadoss wrote:
> > We are working on a notification API from any generic sensor driver to
> > the thermal framework.
> > Please have a look at the 'notify_thermal_framework' API in the patch here:
> > http://www.spinics.net/lists/linux-acpi/msg36049.html
> 
> At first sight these patches look close to what we need as well. Are you
> considering to support the definitions of thermal zones using the device
> tree? Is there a public git tree where we can pull the latest version of
> this code in order to keep in sync with you guys?

As of now, we are getting the definitions done through the platform layer
data. Considerations for device tree .. yes.. but I do not have any sample
implementation..

On the public tree:
Rui is trying to get a public tree from where we can pull Thermal subsystem
changes; and submit patches against this tree.

I hope Rui will publish the link very soon :-)

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
