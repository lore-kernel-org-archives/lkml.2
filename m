Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab2LTPCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:02:32 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:43196 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2LTPC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:02:26 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: RE: [PATCH v2 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Topic: [PATCH v2 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Index: Ac3cl4zZBiTIIXpNQSucdlXbfMCKaAAMiL4AAH5CtFA=
Date: Thu, 20 Dec 2012 15:02:05 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A29FFB@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A22EFA@USINDEM103.corp.hds.com>
 <20121217214506.GF60946@redhat.com>
In-Reply-To: <20121217214506.GF60946@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-20_05:2012-12-20,2012-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212200119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>Though it seems most of patch2 should have been in patch1 (except for the efi part).

OK. I will merge pstore part in patch2 to patch1.


> 
> The only nitpick I have is the name 'is_non_blocking_path'.  I don't know why, but the name doesn't seem exactly right to me.  I was
> thinking something like 'pstore_cannot_block_path' or something.  But it is just a nitpick, so it doesn't matter either way to me.

I will rename the function in next patch.

Seiji
