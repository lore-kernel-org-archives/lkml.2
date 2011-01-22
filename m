Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1AVDAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 22:00:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:33520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1AVDAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 22:00:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,361,1291622400"; 
   d="scan'208";a="699400439"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Sat, 22 Jan 2011 11:00:32 +0800
Subject: RE: [PATCH v4 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Topic: [PATCH v4 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Index: Acu51vDULpzERp/FR0CeehirTVopwQACXEFA
Message-ID: <5D8008F58939784290FAB48F549751983539F50616@shsmsx502.ccr.corp.intel.com>
References: <20110121200941.GA16236@intel.com>
 <20110122015132.GA6748@void.printf.net>
In-Reply-To: <20110122015132.GA6748@void.printf.net>
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

Hi Chris,
Thanks for letting me know this. :)

-Chuanxiao

> -----Original Message-----
> From: Chris Ball [mailto:cjb@laptop.org]
> Sent: Saturday, January 22, 2011 9:52 AM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org;
> akpm@linux-foundation.org
> Subject: Re: [PATCH v4 1/1]mmc: implemented eMMC4.4 enhanced area feature
> 
> Hi Chuanxiao,
> 
> On Sat, Jan 22, 2011 at 04:09:41AM +0800, Chuanxiao Dong wrote:
> > Enhanced area feature is a new feature defined in eMMC4.4 standard. This
> > kind of area can help to improve the performance.
> >
> > MMC driver will read out the enhanced area offset and size and add them
> > to be device attributes. The feature enabling should be done in manufactory.
> > To use this feature, bit ERASE_GRP_DEF should also be set.
> >
> > Documentation/ABI/testing/sysfs-devices-mmc described the two new attributes
> >
> > Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> 
> Looks good, pushed to mmc-next.  Thanks for all the edits to this!
> 
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
