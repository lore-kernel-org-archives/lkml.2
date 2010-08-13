Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab0HMVJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:09:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60516 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0HMVJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:09:02 -0400
Message-ID: <4C65B449.4010905@zytor.com>
Date: Fri, 13 Aug 2010 14:08:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Shaohua Li <shaohua.li@intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch]x86: avoid unnecessary tlb flush
References: <1281065308.29094.5.camel@sli10-desk.sh.intel.com> <20100805221913.4da0f8be.akpm@linux-foundation.org> <1281660475.21194.1.camel@sli10-desk.sh.intel.com> <alpine.DEB.1.00.1008131222110.26182@tigran.mtv.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.1008131222110.26182@tigran.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 12:29 PM, Hugh Dickins wrote:
> 
> Just added Andrea to the Cc list: he did that TLB flush in 1a44e149,
> I'd feel more comfortable noop-ing it on x86 if you've convinced him.
> 
> Hugh

Andrea is probably on his way back from LinuxCon, but looking at the
original patch it might be something that non-x86 architectures need,
but which can be optimized specifically on x86, since x86 has explicit
"no flush needed when going to more permissive" semantics.

	-hpa
