Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0DMUXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:23:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:41343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab0DMUXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,199,1270450800"; 
   d="scan'208";a="265250749"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Steve Wise <swise@opengridcomputing.com>
CC: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Date: Tue, 13 Apr 2010 13:22:40 -0700
Subject: RE: Socket Direct Protocol: help (2)
Thread-Topic: Socket Direct Protocol: help (2)
Thread-Index: AcrbRrmyR/rFhElFTvCo7Eq5L/6kIgAAELlg
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
 <4BC49E2B.3000804@opengridcomputing.com>
 <2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
 <4BC4D22A.6020700@opengridcomputing.com>
In-Reply-To: <4BC4D22A.6020700@opengridcomputing.com>
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

>>> Chien, does the NE020 support FMRs?  I looked at the nes ofed-1.5 code
>>> and it appears to do nothing in the map_phys_fmr functions.
>>>
>>
>> We never implemented map_phys_fmr.  Is it relevant to the # of SGEs?
>>
>No, but SDP uses FMRs.  I don't think it will run without FMR support.
>


Good to know.  Thanks.

Chien


