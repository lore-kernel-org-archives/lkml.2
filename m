Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0H3TRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:17:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:9102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0H3TRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:17:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,294,1280732400"; 
   d="scan'208";a="601951076"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Jean Delvare <khali@linux-fr.org>
CC: "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 30 Aug 2010 12:15:46 -0700
Subject: RE: [lm-sensors] [Patch-next] therm_throt.c: fix missing { and }.
Thread-Topic: [lm-sensors] [Patch-next] therm_throt.c: fix missing { and }.
Thread-Index: ActIGRKayCgwU2QESz270Gxomq/PjQAXks1A
Message-ID: <493994B35A117E4F832F97C4719C4C04A111EEDF@orsmsx505.amr.corp.intel.com>
References: <4C75D3C4.6040802@np.css.fujitsu.com>
	<20100826060822.GA15021@fenghua-desk.sc.intel.com>
	<4C7625D1.4060201@np.css.fujitsu.com>
 <20100827152007.27636fa5@hyperion.delvare>
 <4C7B64A8.2030208@np.css.fujitsu.com>
In-Reply-To: <4C7B64A8.2030208@np.css.fujitsu.com>
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

> So the patch for error handling should be provided as another one. I will make
> a patch for it .

These two patches could be sent as one patch since they are in the same small function.

Thanks.

-Fenghua
