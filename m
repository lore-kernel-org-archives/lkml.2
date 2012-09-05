Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2IEFlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:41:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:16114 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2IEFlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:41:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,372,1344236400"; 
   d="scan'208";a="188924117"
From: "Ren, Yongjie" <yongjie.ren@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH] xen: fix logical error in tlb flushing
Thread-Topic: [PATCH] xen: fix logical error in tlb flushing
Thread-Index: AQHNiyhHR/lL12WnDUufh3nzhb9xgZd7Ot5Q
Date: Wed, 5 Sep 2012 05:41:37 +0000
Message-ID: <1B4B44D9196EFF41AE41FDA404FC0A1018E35D@SHSMSX101.ccr.corp.intel.com>
References: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
 <5037A8E7020000780008A78B@nat28.tlf.novell.com>
 <20120824181721.GC15167@konrad-lan.dumpdata.com>
 <5037E7ED020000780008A7BD@nat28.tlf.novell.com> <5046E47C.2020405@intel.com>
In-Reply-To: <5046E47C.2020405@intel.com>
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
> From: Shi, Alex
> Sent: Wednesday, September 05, 2012 1:35 PM
> To: Jan Beulich
> Cc: Konrad Rzeszutek Wilk; tglx@linutronix.de; mingo@redhat.com;
> linux-kernel@vger.kernel.org; hpa@zytor.com; Ren, Yongjie
> Subject: Re: [PATCH] xen: fix logical error in tlb flushing
> 
> On 08/25/2012 03:45 AM, Jan Beulich wrote:
> 
> >>>> On 24.08.12 at 20:17, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >> On Fri, Aug 24, 2012 at 04:16:39PM +0100, Jan Beulich wrote:
> >>>>>> On 24.08.12 at 10:55, Alex Shi <alex.shi@intel.com> wrote:
> >>>> While TLB_FLUSH_ALL gets passed as 'end' argument to
> >>>> flush_tlb_others(), the Xen code was made to check its 'start'
> >>>> parameter. That may give a incorrect op.cmd to
> MMUEXT_INVLPG_MULTI
> >>>> instead of MMUEXT_TLB_FLUSH_MULTI. Then it causes some page
> can not
> >>>> be flushed from TLB.
> >>>>
> >>>> This patch fixed this issue.
> >>>>
> >>>> Reported-by: Jan Beulich <jbeulich@suse.com>
> >>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> >>>
> >>> Acked-by: Jan Beulich <jbeulich@suse.com>
> 
Tested-by: Yongjie Ren <yongjie.ren@intel.com>

> 
> CC to Yongjie,
> Could you like to test this patch on PV guest
> 
Xen Dom0 and a PV guest kernel with this patch can boot up correctly.

