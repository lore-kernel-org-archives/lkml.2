Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2JEQrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:47:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:50842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab2JEQrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="221076860"
Subject: Re: [PATCH 0/3 v2] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org,
        James Guilford <james.guilford@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cote <david.m.cote@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Min Li <min.a.li@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>
In-Reply-To: <CAA-+O6EkeJQtO=GFhDCZxFoX9L42CAJW71oT2miivOKL9MzDyA@mail.gmail.com>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
	 <1348785854.17632.15.camel@schen9-DESK> <50651163.5050101@zytor.com>
	 <CAA-+O6EkeJQtO=GFhDCZxFoX9L42CAJW71oT2miivOKL9MzDyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 09:47:47 -0700
Message-ID: <1349455667.17632.50.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 10:57 +0800, Herbert Xu wrote:
> 在 2012-9-28 上午10:54，"H. Peter Anvin" <hpa@zytor.com>写道：
> >
> > On 09/27/2012 03:44 PM, Tim Chen wrote:
> >>
> >> Version 2
> >> This version of the patch series fixes compilation errors for
> >> 32 bit x86 targets.
> >>
> >> Version 1
> >> This patch series optimized CRC32C calculations with PCLMULQDQ
> >> instruction for crc32c-intel module.  It speeds up the original
> >> implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
> >> more.  The tcrypt module was enhanced for doing speed test
> >> on crc32c calculations.
> >>
> >
> > Herbert - you are handling this one, right?
> 
> Yes thanks
> 
> 

Hi Herbert, are there any other changes I should do on my end?  Is
the patchset ready to be picked up in crypto-dev?

Thanks.

Tim

