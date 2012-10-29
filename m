Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797Ab2J2Ujx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:39:53 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:33970 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab2J2Ujs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:39:48 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v3 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
Thread-Topic: [PATCH v3 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
Thread-Index: Ac2zwt72eK09iNgHR7WUUZexYzUqOgCcHHoAAAe9wuA=
Date: Mon, 29 Oct 2012 20:39:36 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138995BB@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F045@USINDEM103.corp.hds.com>
 <CAGTjWtDO=Z9y-7XxE5YdFzWsiT3MZ8Jhb4hgywYCQiG+NGcMKA@mail.gmail.com>
In-Reply-To: <CAGTjWtDO=Z9y-7XxE5YdFzWsiT3MZ8Jhb4hgywYCQiG+NGcMKA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-29_03:2012-10-29,2012-10-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210290243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +                               efivars->walk_entry = list_entry(
> > +                                       efivars->walk_entry->list.next,
> > +                                        struct efivar_entry, list);
> 
> odd wrap.
> 

I will fix it.

Thanks,

Seiji
