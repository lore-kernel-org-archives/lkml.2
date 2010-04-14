Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0DNSse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:48:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:10441 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab0DNSsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,206,1270450800"; 
   d="scan'208";a="557964634"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Steve Wise <swise@opengridcomputing.com>
CC: Amir Vadai <amirv@mellanox.co.il>,
       Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Date: Wed, 14 Apr 2010 11:48:07 -0700
Subject: RE: Socket Direct Protocol: help (2)
Thread-Topic: Socket Direct Protocol: help (2)
Thread-Index: Acrb49oHvCGazx5kRmyCfbFZTlUIRQAHxqGA
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C79BD12@azsmsx506.amr.corp.intel.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
	<4BC49E2B.3000804@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
	<4BC4D22A.6020700@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
	<7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il>
 <2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com>
 <4BC5D9D4.7020702@opengridcomputing.com>
In-Reply-To: <4BC5D9D4.7020702@opengridcomputing.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {D1BFD222-9FD9-48E1-A0E7-4DE060676D8D}
x-cr-hashedpuzzle: Ff1u HGI+ InwH P23f REuT Z8C0 oCea tbhL /V9c AEqeug==
 AFOdqA== AFvxQQ== AGJZ/g== AH5S+g== AI/JzQ==
 ALES6A==;10;YQBtAGkAcgB2AEAAbQBlAGwAbABhAG4AbwB4AC4AYwBvAC4AaQBsADsAYQBuAGQAcgBlAGEALgBnAG8AegB6AGUAbABpAG4AbwBAAGwAbgBsAC4AaQBuAGYAbgAuAGkAdAA7AGUAYgBtAHUAbgBzAG8AbgBAAHUAcwAuAGkAYgBtAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AcgBkAG0AYQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQBpAG4AZwBvAEAAZQBsAHQAZQAuAGgAdQA7AHAAYQB2AGUAbABAAHUAYwB3AC4AYwB6ADsAcABlAHQAZQByAHoAQABpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAcgBvAGwAYQBuAGQAZABAAGMAaQBzAGMAbwAuAGMAbwBtADsAcwB3AGkAcwBlAEAAbwBwAGUAbgBnAHIAaQBkAGMAbwBtAHAAdQB0AGkAbgBnAC4AYwBvAG0A;Sosha1_v1;7;{D1BFD222-9FD9-48E1-A0E7-4DE060676D8D};YwBoAGkAZQBuAC4AdABpAG4ALgB0AHUAbgBnAEAAaQBuAHQAZQBsAC4AYwBvAG0A;Wed,
 14 Apr 2010 18:48:07
 GMT;UgBFADoAIABTAG8AYwBrAGUAdAAgAEQAaQByAGUAYwB0ACAAUAByAG8AdABvAGMAbwBsADoAIABoAGUAbABwACAAKAAyACkA
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Tung, Chien Tin wrote:
>>> One more thing - Please open a bug regarding the num_sge limitation at:
>>> https://bugs.openfabrics.org/
>>>
>>
>> Done, Bug 2027.
>>
>> Chien
>>
>
>And 2028 opened to request fastreg support.
>


I am open to test fixes for these two bugs.

Chien
