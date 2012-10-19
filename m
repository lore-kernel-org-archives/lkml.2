Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2JSGfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:35:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:26581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2JSGfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:35:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,610,1344236400"; 
   d="scan'208";a="207990076"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic
 type irqs
Thread-Topic: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic
 type irqs
Thread-Index: AQHNrcCWsMKUnJBYZ0mAKuk+gFhM5ZfAK+Lw
Date: Fri, 19 Oct 2012 06:35:38 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1A4EC6@SHSMSX101.ccr.corp.intel.com>
References: <1350643289.15558.45.camel@cliu38-desktop-build>
 <CAE9FiQVY8TqVeNZc_a23WH0fwKeB2XbVQ080z_PQxGQFmqnajw@mail.gmail.com>
In-Reply-To: <CAE9FiQVY8TqVeNZc_a23WH0fwKeB2XbVQ080z_PQxGQFmqnajw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> impossible !
> 
> where is the irq_desc coming from. ?
Any other chip can call function irq_alloc_descs/irq_alloc_desc() to get irq_desc,
and other chip can has their own chip data.
It is this patch want to point out.
