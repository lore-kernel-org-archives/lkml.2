Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2IUP3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:29:06 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57226 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2IUP3F convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 21 Sep 2012 11:29:05 -0400
Message-Id: <505CA3D9020000780009D0DC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 21 Sep 2012 16:28:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH 0/4] x86: xor-block handling adjustments
References: <504DFB10020000780009A321@nat28.tlf.novell.com>
 <1347304838.26695.99.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1347304838.26695.99.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.09.12 at 21:20, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Mon, 2012-09-10 at 13:37 +0100, Jan Beulich wrote:
>> 1: unify SSE-base xor-block routines
>> 2: improve XMM register spill/fill
>> 3: add alternative SSE implementation only prefetching once per 64-byte line
>> 4: make virtualization friendly
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Jan, There are some relevant changes in tip/x86/fpu branch. Can you
> please build your patches on top of that?

I see (albeit I'm puzzled by the patch there being just 2 days
old, yet your reply was sent over 10 days ago) - I'll probably
re-submit once I merged with the 3.7-rc-s, the more that I
still didn't get anything back from hpa regarding the stack
alignment compiler option he told me about, but use of which
I wasn't able to spot anywhere.

Jan

