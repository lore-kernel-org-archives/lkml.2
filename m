Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2GSVoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:44:12 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:49979 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSVoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:44:10 -0400
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 17:44:09 EDT
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVA=
Date: Thu, 19 Jul 2012 21:43:51 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-19_06:2012-07-19,2012-07-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207190259
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How big a value for efi_pstore_log_num have you tried? Did you see any problems with EFI running out of space? Do you get some
> helpful error message if you pick a number that is too big?

Please calm down... This is RFC patch.

If users specify a number of that is too big, the message will be meaningless.
I just couldn't decide the appropriate number by myself.
Then, I make it tunable.

So, I would like to hear about your opinion.

Do you agree with an idea holding multiple logs?
If so, which number is appropriate? 

Seiji


