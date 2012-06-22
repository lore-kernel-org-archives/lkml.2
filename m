Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2FVSxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:53:40 -0400
Received: from imr3.ericy.com ([198.24.6.13]:40009 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2FVSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:53:39 -0400
Message-ID: <1340390943.2299.139.camel@groeck-laptop>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jean Delvare <khali@linux-fr.org>, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Date: Fri, 22 Jun 2012 11:49:03 -0700
In-Reply-To: <4FE4B2F7.9070302@zytor.com>
References: <20120621162807.3c621d46@endymion.delvare>
	 <4FE34BCB.5050305@linux.intel.com>
	 <20120621190743.2e6601f6@endymion.delvare> <4FE3628C.6000604@zytor.com>
	 <20120621184403.GC15472@liondog.tnic> <4FE37FE9.6000107@linux.intel.com>
	 <20120622065937.GA22167@gmail.com> <4FE4B2F7.9070302@zytor.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 14:01 -0400, H. Peter Anvin wrote:
> On 06/21/2012 11:59 PM, Ingo Molnar wrote:
> > 
> > Plus add a kernel build time check to avoid such string clashes 
> > in the future? These acronyms tend to be short and hard to read, 
> > I'd not be surprised if this repeated in the future.
> > 
> 
> Another *MASSIVE* fail is that an x86 cpufeature was added by a patch
> that went through the hwmon tree without any x86 maintainer ACK, and
> with a subject line that would not have made anyone aware of it:
> 
> a4659053 x86/hwmon: fix initialization of coretemp
> 
> We maintain x86/cpufeature as a separate -tip branch for a reason:
> changes to that stuff mucks with *everything* as it is.

My apologies. Hope I learned a bit since then.

Guenter


