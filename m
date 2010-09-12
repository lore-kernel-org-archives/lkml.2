Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0ILWmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 18:42:04 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56818 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab0ILWmC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 18:42:02 -0400
From: Debashis Dutt <ddutt@Brocade.COM>
To: David Miller <davem@davemloft.net>, "debdut@gmail.com" <debdut@gmail.com>
CC: "jirislaby@gmail.com" <jirislaby@gmail.com>,
        Rasesh Mody <rmody@Brocade.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 15:41:53 -0700
Subject: RE: bna: potential null dereference
Thread-Topic: bna: potential null dereference
Thread-Index: ActSyyCHj1tXgtdqQN+nvnmC4ygmtAAAFiIQ
Message-ID: <F363E7AC84E1B646A0358B281A46F4AEA9C0AE4D03@HQ1-EXCH03.corp.brocade.com>
References: <4C8242CA.3020906@gmail.com>
	<20100912.120230.71108625.davem@davemloft.net>
	<AANLkTi=cZyLYJac8b8MsyAA4HitCvpD3NaH7nifzHDLw@mail.gmail.com>
 <20100912.153805.226772440.davem@davemloft.net>
In-Reply-To: <20100912.153805.226772440.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-11_07:2010-09-10,2010-09-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-1004200000 definitions=main-1009120083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Sunday, September 12, 2010 3:38 PM
To: debdut@gmail.com
Cc: jirislaby@gmail.com; Debashis Dutt; Rasesh Mody; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: bna: potential null dereference

From: Debashis Dutt <debdut@gmail.com>
Date: Sun, 12 Sep 2010 15:35:41 -0700

> A patch is on the way by tomorrow. BTW, this is just an unnecessary
> check that should be removed and not a NULL de-reference.

I've already made a fix in the net-next-2.6 tree.

You should send me fixes like this when you have them and are
reasonably confident of the change, which for something like
this should have been a day or two at most, not a week later.


Sure David. 

Apologize for the delay again. Had too many things on my plate.
Would be more prompt hence forth.

Thanks
--Debashis
