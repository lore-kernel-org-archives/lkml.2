Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1KQB02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:26:28 -0500
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:38113 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab1KQB00 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:26:26 -0500
X-Greylist: delayed 1763 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 20:26:26 EST
From: Rasesh Mody <rmody@brocade.com>
To: Joe Perches <joe@perches.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 16:56:56 -0800
Subject: RE: [PATCH net-next 3/5] bna: Convert MAC_ADDRLEN uses to ETH_ALEN
Thread-Topic: [PATCH net-next 3/5] bna: Convert MAC_ADDRLEN uses to ETH_ALEN
Thread-Index: Acykl2hqZnAJ2uU1S2WQfgAU17M78AAAGtXQ
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86AC9CEA6EAD@HQ1-EXCH01.corp.brocade.com>
References: <cover.1321472142.git.joe@perches.com>
 <8a6f9ad67a3d580565cafb7a44cec0165831c35d.1321472143.git.joe@perches.com>
In-Reply-To: <8a6f9ad67a3d580565cafb7a44cec0165831c35d.1321472143.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-11-16_08:2011-11-16,2011-11-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1111160279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Joe Perches [mailto:joe@perches.com]
>Sent: Wednesday, November 16, 2011 11:38 AM
>
>Reduce the number of #defines, use the normal #define from if_ether.h

Patch looks fine.
Thanks,
Rasesh

Acked-by: Rasesh Mody <rmody@brocade.com>

