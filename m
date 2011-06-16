Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1FPJHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:07:30 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36149 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab1FPJH2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:07:28 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Jack Wang <jack_wang@usish.com>,
        "'James Bottomley'" <James.Bottomley@HansenPartnership.com>
CC: "yxlraid@gmail.com" <yxlraid@gmail.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Thu, 16 Jun 2011 02:04:42 -0700
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Topic: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Index: AcwrIR/qdpMMo2uOTdi6EtZ/SnmPkgAAZ5KAACgYoPAAAOfC4AABCYdAAABOEGAAA867gAAA6NjQAAMaV6AAAIc6oAABFNUQAACOI5AAAiHGgAABI+NA
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66E0E@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
 <637AF86F1A314F15B816411A580575F0@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
 <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
 <C8FBA6A948D643679B01520A89FAC48A@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66D1E@SC-VEXCH4.marvell.com>
 <E3CF09ECAD244C00A4C096DB374E140E@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66D88@SC-VEXCH4.marvell.com>
 <4F7167A354D8476AB58FD36CA6321960@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66DB6@SC-VEXCH4.marvell.com>
 <6E6072BD03F348168F749B19B2BA90D3@usish.com.cn>
In-Reply-To: <6E6072BD03F348168F749B19B2BA90D3@usish.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>[Jack Wang] 
>No, I mean you when you set connection rate in OPEN Address frame, you
>compare your HBA linkrate with the linkrate of the phy you want to open, and
>chose the minor.

I don't understand. What is the purpose of sas_ex_get_linkrate function?

