Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762659Ab2FVSHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:07:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33710 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2FVSHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:07:12 -0400
Message-ID: <4FE4B2F7.9070302@zytor.com>
Date: Fri, 22 Jun 2012 11:01:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jean Delvare <khali@linux-fr.org>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
References: <20120621162807.3c621d46@endymion.delvare> <4FE34BCB.5050305@linux.intel.com> <20120621190743.2e6601f6@endymion.delvare> <4FE3628C.6000604@zytor.com> <20120621184403.GC15472@liondog.tnic> <4FE37FE9.6000107@linux.intel.com> <20120622065937.GA22167@gmail.com>
In-Reply-To: <20120622065937.GA22167@gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 11:59 PM, Ingo Molnar wrote:
> 
> Plus add a kernel build time check to avoid such string clashes 
> in the future? These acronyms tend to be short and hard to read, 
> I'd not be surprised if this repeated in the future.
> 

Another *MASSIVE* fail is that an x86 cpufeature was added by a patch
that went through the hwmon tree without any x86 maintainer ACK, and
with a subject line that would not have made anyone aware of it:

a4659053 x86/hwmon: fix initialization of coretemp

We maintain x86/cpufeature as a separate -tip branch for a reason:
changes to that stuff mucks with *everything* as it is.

	-hpa
