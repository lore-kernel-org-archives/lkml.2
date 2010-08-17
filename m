Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0HQGLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:11:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48265 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0HQGL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:11:28 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>
Date: Tue, 17 Aug 2010 01:08:04 -0500
Subject: RE: [PATCH] iommu: fix end address of vm area comparation in
 alloc_iovm_area
Thread-Topic: [PATCH] iommu: fix end address of vm area comparation in
 alloc_iovm_area
Thread-Index: Acs9zNfIUn3La5qRReiyq57pfrLOyQABbakq
Message-ID: <496565EC904933469F292DDA3F1663E602CA4D894D@dlee06.ent.ti.com>
References: <496565EC904933469F292DDA3F1663E602CA4D8949@dlee06.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CA4D894C@dlee06.ent.ti.com>,<20100817.082706.39158708.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20100817.082706.39158708.Hiroshi.DOYU@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From: Hiroshi DOYU [Hiroshi.DOYU@nokia.com]
>Sent: Tuesday, August 17, 2010 12:27 AM
>To: Guzman Lugo, Fernando
>Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; Kanigeri, Hari
>Subject: Re: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
>
>From: "ext Guzman Lugo, Fernando" <fernando.lugo@ti.com>
>Subject: RE: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
>Date: Tue, 17 Aug 2010 06:48:14 +0200
>
>> From: linux-omap-owner@vger.kernel.org [linux-omap-owner@vger.kernel.org] On Behalf Of Guzman Lugo, Fernando [fernando.lugo@ti.com]
>> Sent: Monday, August 16, 2010 10:51 PM
>> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: Hiroshi.DOYO@nokia.com; Kanigeri, Hari
>> Subject: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
>>
>> From cc48c0adaee97c8385a356aefa5b64a51818b4fd Mon Sep 17 00:00:00 2001
>> From: Fernando Guzman Lugo <x0095840@ti.com>
>> Date: Mon, 16 Aug 2010 22:28:24 -0500
>> Subject: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
>>
>> End address of the vm area is “start + bytes -1”,
>> not “start + byte”. This patch fixes that issue by doing
>> an inclusive comparison with tmp->da_start. This issue
>> was preventing allocate an area of size exactly the same
>> than the free area. I did no change the value of da_end
>> of each vm area because it is used to get area size in
>> several places.
>
>Ok for me. Is this patch against the latest?

not it isn't, but I don't think it could have issues applying. However I will resend it, base against the latest and include you ack.

Regards,
Fernando.

