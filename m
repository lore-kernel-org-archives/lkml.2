Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1LMBmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:42:07 -0500
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44945 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab1LMBmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:42:03 -0500
X-Greylist: delayed 3372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 20:42:03 EST
From: Jing Huang <huangj@Brocade.COM>
To: Joe Perches <joe@perches.com>, roel <roel.kluin@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Krishna Gudipati <kgudipat@Brocade.COM>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Mon, 12 Dec 2011 16:45:40 -0800
Subject: RE: drivers/scsi/bfa/bfa_fcpim.c: boolean and / or confusion
Thread-Topic: drivers/scsi/bfa/bfa_fcpim.c: boolean and / or confusion
Thread-Index: Acy5Koy4cF9hmQ+RQpSgEv9gPFvHQwABbfOg
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86AE58BEFC5F@HQ1-EXCH01.corp.brocade.com>
References: <4EE688FC.8090606@gmail.com> <1323734563.3837.6.camel@joe2Laptop>
In-Reply-To: <1323734563.3837.6.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_10:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1112120279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBD1gSTj023367

>On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
>> The test not [val1] or not [val2] always evaluates to true
>
>Looking at drivers with:
>
>$ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-
>]+\s*\)\s*\|\|\s*\(\s*\1\s*\!\=" drivers
>
>drivers/scsi/bfa/bfa_fcpim.c:			    ((cdb->scsi_cdb[0] != INQUIRY) ||
>			    (cdb->scsi_cdb[0] != REPORT_LUNS))) {
>
>Likely the || should be &&

This is a bug and it should be &&. Will provide a fix.

Thanks
Jing
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
