Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2CXQEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:04:15 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:52038 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2CXQEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:04:14 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Sat, 24 Mar 2012 12:03:56 -0400
Subject: RE: [Patch]Introduce get_reason_str() to pstore
Thread-Topic: [Patch]Introduce get_reason_str() to pstore
Thread-Index: Ac0JjM4agLEQr2UAS2aN7HuAQKI04gASstAA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E4B8EF8D0@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E32064CDF@USINDEVS01.corp.hds.com>
 <20120324001054.4eb82767.akpm@linux-foundation.org>
In-Reply-To: <20120324001054.4eb82767.akpm@linux-foundation.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=1 spamscore=1
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1203240174
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Better:
> 
> static char *reason_str[] = {
> 	[KMSG_DUMP_OOPS] = "Oops",
> 	[KMSG_DUMP_PANIC] = "Panic",
> 	...
> 	[KMSG_DUMP_POWEROFF] = "Poweroff",
> };

Thanks, Andrew.

I will update my patch.

Seiji
