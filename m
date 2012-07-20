Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2GTQ4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:56:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:60805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab2GTQ4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:56:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181482736"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVAAAP4IQAAA0SRAAAJWEXAAAc9d8AAUbUAAABWxqgAAAkSNAAAJzEsw
Date: Fri, 20 Jul 2012 16:56:02 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1936ECD8@ORSMSX104.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB286FB@USINDEM103.corp.hds.com>
 <20120720142934.GF5637@redhat.com>
In-Reply-To: <20120720142934.GF5637@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What is the harm of not using this and just letting the number be infinite (or until EFI runs out of space)?  Is it a big deal if extra failures
> > are logged?

The big question is what happens when EFI runs out of space. Matthew avoided
the question by implementing the "just one record" policy. Was this because he
has some specific knowledge about what happens, or does he just have an
irrational[1] fear that the EFI implementation will handle this poorly?

Without some tests on at least a couple of different platforms that show that
EFI handles out of space conditions gracefully, I continue to have concerns.

-Tony

[1] Perhaps his fears are rational given how many other places he has found
EFI not doing what we'd expect or want.
