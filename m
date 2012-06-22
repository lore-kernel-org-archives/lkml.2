Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428Ab2FVG7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 02:59:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51837 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761388Ab2FVG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 02:59:42 -0400
Date: Fri, 22 Jun 2012 08:59:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
Message-ID: <20120622065937.GA22167@gmail.com>
References: <20120621162807.3c621d46@endymion.delvare>
 <4FE34BCB.5050305@linux.intel.com>
 <20120621190743.2e6601f6@endymion.delvare>
 <4FE3628C.6000604@zytor.com>
 <20120621184403.GC15472@liondog.tnic>
 <4FE37FE9.6000107@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE37FE9.6000107@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 06/21/2012 11:44 AM, Borislav Petkov wrote:
> > On Thu, Jun 21, 2012 at 11:06:04AM -0700, H. Peter Anvin wrote:
> >> On 06/21/2012 10:07 AM, Jean Delvare wrote:
> >>>
> >>> And FWIW, X86_FEATURE_DS has no user in the kernel. Doesn't look like a
> >>> key feature to me, but maybe my view is biased...
> >>>
> >>
> >> No, but apparently perfmon2 depends on it, in userspace, and it relies
> >> on the string.
> >>
> >> So this is a nonstarter.
> > 
> > Maybe call the sensor thing "dtsen" or something similarly short but not
> > "dts"?
> > 
> 
> Yeah, that's what we have to do.  Sigh.

Plus add a kernel build time check to avoid such string clashes 
in the future? These acronyms tend to be short and hard to read, 
I'd not be surprised if this repeated in the future.

Thanks,

	Ingo
