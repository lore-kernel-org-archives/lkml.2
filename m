Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2GBEWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:22:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:56235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2GBEWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:22:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172359695"
From: "Iyer, Sundar" <sundar.iyer@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        Paul Mundt <lethal@linux-sh.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Monroy, German" <german.monroy@intel.com>
Subject: RE: [PATCH v3 1/1] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Topic: [PATCH v3 1/1] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Index: AQHNUoaUtY9NzmhTpU6Ghl9xYsQAHpcKJmuAgAtIx9A=
Date: Mon, 2 Jul 2012 04:22:15 +0000
Message-ID: <2FABAEF0D3DCAF4F9C9628D6E2F9684521253F@BGSMSX102.gar.corp.intel.com>
References: <1340596507-12702-1-git-send-email-sundar.iyer@intel.com>
 <20120625053156.GB24033@linux-sh.org>
In-Reply-To: <20120625053156.GB24033@linux-sh.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas/Paul,

Any comments on the latest patch set?

Thanks

>-----Original Message-----
>From: Paul Mundt [mailto:lethal@linux-sh.org]
>Sent: Monday, June 25, 2012 11:02 AM
>To: Iyer, Sundar
>Cc: tglx@linutronix.de; linux-kernel@vger.kernel.org; arjan@linux.intel.com; Monroy,
>German
>Subject: Re: [PATCH v3 1/1] x86/irq: handle chained interrupts during IRQ migration
>
>On Mon, Jun 25, 2012 at 09:25:07AM +0530, Sundar Iyer wrote:
>> Chained interrupt handlers dont have an irqaction and hence are not
>> handled during migrating interrupts when some cores go offline.
>>
>> Handle this by introducing a irq_is_chained() check which is based on
>> the the CHAINED flag being set for such interrupts. fixup_irq() can
>> then handle such interrupts and not skip them over.
>>
>> Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
>> Reviewed-by: Yang, Fei <fei.yang@intel.com>
>> Tested-by: Ng, Cheon-woei <cheon-woei.ng@intel.com>
>
>Looks better to me.
