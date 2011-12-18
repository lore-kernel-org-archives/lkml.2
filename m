Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1LRItX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:49:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1LRItV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:49:21 -0500
Date: Sun, 18 Dec 2011 09:47:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
Message-ID: <20111218084732.GH4144@elte.hu>
References: <CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
 <4EE5291C.1030302@gmail.com>
 <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
 <4EE68C80.7000408@gmail.com>
 <1323735902.1984.165.camel@sbsiddha-desk.sc.intel.com>
 <CAE9FiQW5GNTqgpFtV1JuOY51H4sUBCwLwJhJqxVtwksCFsdvHQ@mail.gmail.com>
 <1323740475.1984.171.camel@sbsiddha-desk.sc.intel.com>
 <CAE9FiQWxYgCd2AVzXWfuqFA6NkgzgD0+XuAkUfEG1GN2EFBpTg@mail.gmail.com>
 <CAE9FiQVhLKhRT=XivpG6KHYhpA+HN695CZ3cQ82-teaRPEBxNg@mail.gmail.com>
 <4EEB4EA5.2040607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB4EA5.2040607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Berck E. Nash <flyboy@gmail.com> wrote:

> On 12/12/2011 10:13 PM, Yinghai Lu wrote:
> > please check -v7.
> 
> Works just fine for me.

That's interesting.

Now if this could be made completely automatic (no extra 
parameter passing), then we have a usable fallback mode - which 
is preferred to crashing the box.

Thanks,

	Ingo
