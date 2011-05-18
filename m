Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab1ERC7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:59:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:15852 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab1ERC7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:59:22 -0400
X-ExtLoop1: 1
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 May 2011 19:57:17 -0700
Subject: RE: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
Thread-Topic: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
Thread-Index: AcwU6AcqkTkuQutIQq2VrMC/xGECYAAHuuJA
Message-ID: <493994B35A117E4F832F97C4719C4C04011505C394@orsmsx505.amr.corp.intel.com>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <1305581685-5144-4-git-send-email-fenghua.yu@intel.com>
 <20110517021006.GA6732@srcf.ucam.org>
 <493994B35A117E4F832F97C4719C4C04011505C272@orsmsx505.amr.corp.intel.com>
 <4DD300F5.9070101@zytor.com>
In-Reply-To: <4DD300F5.9070101@zytor.com>
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

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, May 17, 2011 4:13 PM
> To: Yu, Fenghua
> Cc: Matthew Garrett; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Linus Torvalds; Avi Kivity; Arjan van de Ven; Andrew Morton; Andi
> Kleen; linux-kernel
> Subject: Re: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
> 
> On 05/17/2011 04:08 PM, Yu, Fenghua wrote:
> >>
> >> Are EFI runtime service pages currently set up appropriately?
> >
> > They are not set up yet. efi init is called after this.
> >
> > But at this time there is no user space code yet. So there is no SMEP
> violation chance until later when any user space page table is setup.
> >
> 
> Are EFI runtime pages set up with U=0?  I would argue it is a bug if
> they aren't, but we want to make sure that there isn't such a bug.
> 
> 	-hpa

The runtime services are ioremapped. So they should be U=0.

Thanks.

-Fenghua
