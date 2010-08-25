Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0HYXQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:16:21 -0400
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:35956 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0HYXQT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:16:19 -0400
X-Greylist: delayed 4948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 19:16:19 EDT
From: Rasesh Mody <rmody@brocade.com>
To: David Miller <davem@davemloft.net>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jing Huang <huangj@brocade.com>, "Debashis Dutt" <ddutt@brocade.com>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Date: Wed, 25 Aug 2010 14:53:39 -0700
Subject: RE: linux-next: build failure after merge of the final tree (net
 tree related)
Thread-Topic: linux-next: build failure after merge of the final tree (net
 tree related)
Thread-Index: ActEmHP8yw2t82l2QtGDOxrkU8NhsAABro7w
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A4AE2260D2@HQ1-EXCH01.corp.brocade.com>
References: <20100825120927.c469ce20.sfr@canb.auug.org.au>
	<E5313AF6F2BFD14293E5FD0F94750F86A4AE225EE8@HQ1-EXCH01.corp.brocade.com>
	<20100825.003526.35028751.davem@davemloft.net>
 <20100825.135957.112609658.davem@davemloft.net>
In-Reply-To: <20100825.135957.112609658.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-25_10:2010-08-25,2010-08-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-1004200000 definitions=main-1008250181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: David Miller <davem@davemloft.net>
>Date: Wed, 25 Aug 2010 00:35:26 -0700 (PDT)
>
>> From: Rasesh Mody <rmody@brocade.com>
>> Date: Tue, 24 Aug 2010 21:22:19 -0700
>> 
>>> All,
>>> 
>>> We are working on a fix and we will submit a patch soon.
>
>Well, where is the fix and why is it taking so long?
>
>Stephen Rothwell is going to build his -next tree for today any minute
>now and will have to revert your driver from his tree again since a
>fix is not yet in place.
>
>If I don't see a fix quickly, I'll fix it however I like and however
>I like might be yanking your driver out of the tree.
>
>Thanks.

Hi David,

We have submitted a patch to fix this issue.
Please let us know if this is good.

Thanks,
Rasesh
