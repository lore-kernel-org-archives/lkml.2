Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215Ab2EPKkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:40:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:37401 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966898Ab2EPKkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100709453"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Avi Kivity <avi@redhat.com>, Xudong Hao <xudong.hao@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH 2/4] Add parameter to control A/D bits support
Thread-Topic: [PATCH 2/4] Add parameter to control A/D bits support
Thread-Index: AQHNMv/kbF/dGzD/4Ea4LhMhAXQigZbLnLsAgACdQ/A=
Date: Wed, 16 May 2012 10:40:04 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDC52D9@SHSMSX102.ccr.corp.intel.com>
References: <20120516010818.GC14256@hp-xd.sh.intel.com>
 <4FB3702A.3040900@redhat.com>
In-Reply-To: <4FB3702A.3040900@redhat.com>
Accept-Language: en-US
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
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Wednesday, May 16, 2012 5:15 PM
> To: Xudong Hao
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Shan, Haitao; Zhang,
> Xiantao; Hao, Xudong
> Subject: Re: [PATCH 2/4] Add parameter to control A/D bits support
> 
> On 05/16/2012 04:08 AM, Xudong Hao wrote:
> > Add kernel parameter to control A/D bits support, it's on by default.
> >
> > Signed-off-by: Haitao Shan <haitao.shan@intel.com>
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> >
> > ---
> >  arch/x86/kvm/vmx.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index d2bd719..811a61e 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -64,6 +64,9 @@ static bool __read_mostly enable_unrestricted_guest =
> 1;
> >  module_param_named(unrestricted_guest,
> >             enable_unrestricted_guest, bool, S_IRUGO);
> >
> > +static int __read_mostly enable_ept_ad_bits = 1;
> > +module_param_named(ept_ad_bits, enable_ept_ad_bits, bool, S_IRUGO);
> 
> Please use bool.  And call the external name 'eptad', for easier use.
> 

OK, will modify them in patch v2.

Thanks,
-Xudong

> 
> --
> error compiling committee.c: too many arguments to function

