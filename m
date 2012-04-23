Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2DWK5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:57:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39844 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab2DWK5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:57:19 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "V, Aneesh" <aneesh@ti.com>, Greg KH <greg@kroah.com>
CC: Paul Walmsley <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hunter, Jon" <jon-hunter@ti.com>
Subject: RE: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Thread-Topic: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Thread-Index: AQHNA78a9lhevdYvxk2HV7vF+jKLg5aWSLeAgAAEfgCAAPKRgIARNXwQ
Date: Mon, 23 Apr 2012 10:56:32 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E96E7C5@DBDE01.ent.ti.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com>
 <CAM=4YEQ6_+7xPwi2jucks1P9p8tO3cSG7S0s=VVJVrueb4fB=g@mail.gmail.com>
In-Reply-To: <CAM=4YEQ6_+7xPwi2jucks1P9p8tO3cSG7S0s=VVJVrueb4fB=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aneesh,

On Fri, Apr 13, 2012 at 01:28:55, V, Aneesh wrote:

> Thanks. I will wait for your review then. Once I have your comments
> I will re-work and submit in the new directory structure proposed.

Do you have a plan on submitting EMIF driver in the new proposed
(drivers/memory) directory. Or shall I submit GPMC driver by creating
the new "memory" directory.

Regards
Afzal
