Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2GXUkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:40:16 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:54345 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2GXUkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:40:13 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVAAAP4IQAAA0SRAAAJWEXAAAc9d8AAOI+0AAK5hfwAAMAYhEAAJzp+AAADntgAAA3nmAAAHQ+6g
Date: Tue, 24 Jul 2012 20:39:53 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB346A4@USINDEM103.corp.hds.com>
References: <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com> <20120723141632.GB23047@srcf.ucam.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB33479@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370A1B@ORSMSX104.amr.corp.intel.com>
 <20120724181820.GA23820@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F19370CA2@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19370CA2@ORSMSX104.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-24_04:2012-07-24,2012-07-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207240215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One thing that's worth noting - UEFI systems will typically only
> > recover deleted space on reset. create->delete->create->delete will
> > reduce available space until the platform is rebooted, at which point
> > the deleted portion will become available again.
> 
> Some ACPI/ERST systems do this too :-(

So, we don't need to introduce a overwriting policy.
I will make a patch using QueryVariableInfo and just writing multiple logs.

Seiji
