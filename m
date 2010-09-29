Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0I2NkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:40:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:53632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0I2NkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:40:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,253,1283756400"; 
   d="scan'208";a="559024965"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 29 Sep 2010 21:39:54 +0800
Subject: RE: [PATCH v11 12/17] Add a kconfig entry and make entry for mp
 device.
Thread-Topic: [PATCH v11 12/17] Add a kconfig entry and make entry for mp
 device.
Thread-Index: ActeS9fI+rkt428QTcambTJUPSO8PQBj9xaw
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D792EC64F8155@shsmsx502.ccr.corp.intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
	 <0eed02838e581f2ef2247be8e69bc34cdecce6b2.1285385607.git.xiaohui.xin@intel.com>
 <1285595805.2263.13.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1285595805.2263.13.camel@achroite.uk.solarflarecom.com>
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

Thanks, I will move this in order next version.

Thanks
Xiaohui

>-----Original Message-----
>From: Ben Hutchings [mailto:bhutchings@solarflare.com]
>Sent: Monday, September 27, 2010 9:57 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mingo@elte.hu; davem@davemloft.net; herbert@gondor.hengli.com.au;
>jdike@linux.intel.com
>Subject: Re: [PATCH v11 12/17] Add a kconfig entry and make entry for mp device.
>
>This patch is in the wrong position in the sequence.  It needs to be
>applied after mpassthru.c is created, not before.
>
>Ben.
>
>--
>Ben Hutchings, Senior Software Engineer, Solarflare Communications
>Not speaking for my employer; that's the marketing department's job.
>They asked us to note that Solarflare product names are trademarked.

