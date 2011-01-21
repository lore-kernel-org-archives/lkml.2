Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1AURn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:43:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:27094 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1AURn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:43:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,359,1291622400"; 
   d="scan'208";a="595247718"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Sat, 22 Jan 2011 01:43:21 +0800
Subject: RE: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Topic: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Index: Acu5f8i0Xhj0kOonSS6ZTaoyZc+ZogAEj3Zw
Message-ID: <5D8008F58939784290FAB48F549751983539F505FF@shsmsx502.ccr.corp.intel.com>
References: <20110120075556.GA23566@intel.com>
 <20110120161248.GA11774@void.printf.net>
 <5D8008F58939784290FAB48F5497519835341813A7@shsmsx502.ccr.corp.intel.com>
 <20110121080422.GA21763@void.printf.net>
 <5D8008F58939784290FAB48F549751983539F50558@shsmsx502.ccr.corp.intel.com>
 <20110121152750.GA32551@void.printf.net>
In-Reply-To: <20110121152750.GA32551@void.printf.net>
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

> -----Original Message-----
> From: Chris Ball [mailto:cjb@laptop.org]
> Sent: Friday, January 21, 2011 11:28 PM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org;
> akpm@linux-foundation.org
> Subject: Re: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
> 
> Hi Chuanxiao,
> 
> On Fri, Jan 21, 2011 at 05:12:00PM +0800, Dong, Chuanxiao wrote:
> > I have used the checkpatch.pl to check this patch, and no error or warning
> found....
> 
> Oh, you're right!  I wonder if that's because it's in a .txt file rather
> than a source file.  Not sure how to get it to warn about this, then.
> 
> > > Ah, I wasn't clear -- I meant the bytes/kilobytes units, not the data type
> > > sizes.  e.g.:
> > >
> > > +   size_t          enhanced_area_size;             /* Units: KB */
> > I think the units of _offset and _size should be easy for user to understand, so just
> choose the Byte for _offset and Kbyte for _size...
> > And as spec said, the _size is (ENH_SIZE_MULT_2 << 16 + ENH_SIZE_MULT_1 <<
> 8 + ENH_SIZE_MULT_0) x HC_WP_GRP_SIZE x HC_ERASE_GPR_SIZE x 512kBytes. It
> must be Kbytes aligned. That is another reason to choose it.
> 
> I agree that we we should use these units, I'm just arguing that we
> might as well mention them in the comment area.  The other card.h
> definitions mention their unit sizes too.  At the moment your comments
> for card.h simply repeat the variable name, which isn't useful -- why
> not make them repeat some useful and not-necessarily-obvious information
> instead?
Sure, Chris. I will take care of such things in my future submissions. Of cause including the next v4 enhanced area feature patch. :) I also remember to fix the compile warnings. Thanks a lot, Chris.

Thanks
Chuanxiao
