Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1BBXav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:30:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:23262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1BBXau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:30:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,416,1291622400"; 
   d="scan'208";a="703397943"
From: "Zhao, Shanyu" <shanyu.zhao@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Lance Zimmerman <lance.zimmerman@atheros.com>,
        Prem Kumar <Prem.Kumar@atheros.com>
Date: Wed, 2 Feb 2011 15:30:48 -0800
Subject: RE: Backporting other subsystems on Linux
Thread-Topic: Backporting other subsystems on Linux
Thread-Index: AcvDKEerqntXsf+uTnikPN0PefQh3QAB855A
Message-ID: <380B2771CDD78E46856E6B788D9F1997D27D88D2@orsmsx503.amr.corp.intel.com>
References: <380B2771CDD78E46856E6B788D9F1997D2468080@orsmsx503.amr.corp.intel.com>
 <BD672EAEE3AD2C47A7120B0973C3FB3A50F0AC156A@SC1EXMB-MBCL.global.atheros.com>
 <380B2771CDD78E46856E6B788D9F1997D27D86D2@orsmsx503.amr.corp.intel.com>
 <20110202220926.GB3035@tux> <20110202222645.GE3035@tux>
In-Reply-To: <20110202222645.GE3035@tux>
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

Hi Luis,

Thank you for the detailed explanation! 

I just started to explore potential options of backporting USB subsystems. Currently I'm not at the point where I'm ready to backport drivers. I'll work on that later.

>> The next question you have which you have not asked me yet is how do you
>address
>> cherry picks or patches not upstream. For that I have added three
>directories,
>> they are self described by their names with a URL to their respective
>README:
>>
>>   * linux-next-cherry-picks/ http://bit.ly/h76wrL
>>   * linux-next-pending/      http://bit.ly/eY4aCY
>>   * pending-stable/          http://bit.ly/dOsi7J
>>
>> What I really need to get to at some point is to use implement a
>> menuconfig thingy, we already drag the Kconfigs in but use config.mk for
>> makefile/dependency mapping. Patches welcomed.
Well, I actually didn't have that question in mind. :) I read the README files in these folders and I totally agree that there should not be patches under these 3 folders. I think compat-wireless should just fulfill the function of backporting a driver from a (stable) kernel to an old kernel. Not adding additional patches. Driver developers should strive to make important patches into the stable releases. 

>
>BTW one idea I have as of recent is to consider using Hudson for automatic
>build testing for compat-wireless but haven't yet mucked with it. Eventually
>this will be more and more important as time goes by and we support older
>kernels. The goal is to at the *very least* always support down to the last
>stable 2.6 kernel listed on kernel.org, today that is 2.6.27 and I think its
>a safe promise to commit to backporting *at least* to that kernel. We go
>beyond 2.6.27 though today.
This is a good idea!

Shanyu
