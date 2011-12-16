Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891Ab1LPWTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:19:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:12142 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644Ab1LPWTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:19:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87443136"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Date: Fri, 16 Dec 2011 14:19:07 -0800
Subject: RE: [30/45] hwmon: (coretemp) Fix oops on CPU offlining
Thread-Topic: [30/45] hwmon: (coretemp) Fix oops on CPU offlining
Thread-Index: Acy8LDyUqidqEdysS3O7fYiPZWVw8gAFG2AA
Message-ID: <43F901BD926A4E43B106BF17856F075501A4D686BE@orsmsx508.amr.corp.intel.com>
References: <20111216194603.GA15028@kroah.com>
 <20111216194211.684013527@clark.kroah.org>
In-Reply-To: <20111216194211.684013527@clark.kroah.org>
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



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, December 16, 2011 11:41 AM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org;
> stable@kernel.org
> Cc: torvalds@linux-foundation.org; akpm@linux-foundation.org;
> alan@lxorguk.ukuu.org.uk; Guenter Roeck; Greg KH; Jean Delvare; R,
> Durgadoss; Yu, Fenghua
> Subject: [30/45] hwmon: (coretemp) Fix oops on CPU offlining
> 
> 3.0-stable review patch.  If anyone has any objections, please let me
> know.
> 
> ------------------
> 
> This is for stable kernel branch 3.0 only. Previous and later versions
> have different code paths and are not affected by this bug.
> 
> This is the same fix as "hwmon: (coretemp) Fix oops on driver load"
> but for the CPU offlining case. Sorry for missing it at first.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Durgadoss R <durgadoss.r@intel.com>
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Fenghua Yu <fenghua.yu@intel.com>

