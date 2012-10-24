Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2JXQsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:48:18 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:45747
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075Ab2JXQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:48:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I1432I4015Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MCEPCA-01-1UA-02
X-M-MSG: 
Date: Wed, 24 Oct 2012 11:48:08 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Tom Rini <trini@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
Message-ID: <20121024164808.GA11779@jshin-Toonie>
References: <20121022144020.GA14425@jshin-Toonie>
 <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com>
 <20121022183858.GA31185@jshin-Toonie>
 <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com>
 <5085ABEF.3060502@linux.intel.com>
 <CAE9FiQW0rQFUgjiYjByA91XCUUqo59zz2kXc9Z5wXk+3vKPKaQ@mail.gmail.com>
 <5085B207.5010907@linux.intel.com>
 <CAE9FiQVt5LN6_wDvS2G+UULD4Ba2CF=zLhg4RULSKbfbct0NLg@mail.gmail.com>
 <5085BA4A.30800@zytor.com>
 <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 04:35:18PM -0700, Yinghai Lu wrote:
> On Mon, Oct 22, 2012 at 2:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >>
> >> We never know that bios guys will not let bios produce crazy e820 map.
> >>
> >
> > Yeah, well, that just *will* happen... that's a given.
> >
> > We can trim those ranges, though.  Who cares if we lose some RAM.
> >
> 
> please check attached two patches that handle partial pages for 3.7.
> 
> and you still need patch in
>    https://lkml.org/lkml/2012/8/24/469
> 
> to address early page table size calculation problem for Tom Rini

Acked-by: Jacob Shin <jacob.shin@amd.com>

hpa, we need this patch: https://lkml.org/lkml/2012/8/24/469 and the above
2 from Yinghai to handle corner case E820 layouts.

I got an email from Greg KH that 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a is
queued for stable, so these need to go to stable as well.

Thanks,

-Jacob

> 
> Thanks
> 
> Yinghai




