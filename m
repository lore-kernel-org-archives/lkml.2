Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2HQUnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:43:35 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:60692 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab2HQUn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:43:27 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 1/2] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Topic: [RFC][PATCH 1/2] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Index: AQHNfLV2h8zl2XlSe0uwML4APa7lBpdeeBOA
Date: Fri, 17 Aug 2012 20:43:13 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413800114@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41380007C@USINDEM103.corp.hds.com>
 <CAGTjWtBnx3nLzQz8Sk=6M3_iOwfEVP81s+7mFucqG_VBKjeUkQ@mail.gmail.com>
In-Reply-To: <CAGTjWtBnx3nLzQz8Sk=6M3_iOwfEVP81s+7mFucqG_VBKjeUkQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-17_03:2012-08-17,2012-08-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208170225
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This isn't necessary (nor desirable).  If the API here is that we get called from process context for ->open and ->close(), just use the
> spin_lock_irq and spin_unlock_irq variants for these paths (avoiding the need to remove the lock acquire in ->open and ->close.

OK. I will update my patch based on your comment above.
Thank you for your quick response.

Seiji

