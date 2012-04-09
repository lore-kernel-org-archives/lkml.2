Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2DIVRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:17:10 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43014 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab2DIVRH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:17:07 -0400
From: Rasesh Mody <rmody@brocade.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "trivial@kernel.org" <trivial@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 9 Apr 2012 14:14:17 -0700
Subject: RE: [PATCH 06/26] bna: remove redundant NULL test before
 release_firmware()
Thread-Topic: [PATCH 06/26] bna: remove redundant NULL test before
 release_firmware()
Thread-Index: Ac0WkmUkINMlaFARRle2Tkw8hhpQawAAvgtg
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86B3A74DF5D5@HQ1-EXCH01.corp.brocade.com>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204092210470.13925@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204092210470.13925@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-04-09_03:2012-04-09,2012-04-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1112030000 definitions=main-1204090250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Jesper Juhl [mailto:jj@chaosbits.net]
>Sent: Monday, April 09, 2012 1:50 PM
>To: linux-kernel@vger.kernel.org
>
>release_firmware() does its own NULL test so explicit test before call
>is unneeded.
>
>Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks Jesper!

Acked-by: Rasesh Mody <rmody@brocade.com>
