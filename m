Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168Ab2FUULX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:11:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:7931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152Ab2FUULW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183402243"
Message-ID: <4FE37FE9.6000107@linux.intel.com>
Date: Thu, 21 Jun 2012 13:11:21 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
References: <20120621162807.3c621d46@endymion.delvare> <4FE34BCB.5050305@linux.intel.com> <20120621190743.2e6601f6@endymion.delvare> <4FE3628C.6000604@zytor.com> <20120621184403.GC15472@liondog.tnic>
In-Reply-To: <20120621184403.GC15472@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 11:44 AM, Borislav Petkov wrote:
> On Thu, Jun 21, 2012 at 11:06:04AM -0700, H. Peter Anvin wrote:
>> On 06/21/2012 10:07 AM, Jean Delvare wrote:
>>>
>>> And FWIW, X86_FEATURE_DS has no user in the kernel. Doesn't look like a
>>> key feature to me, but maybe my view is biased...
>>>
>>
>> No, but apparently perfmon2 depends on it, in userspace, and it relies
>> on the string.
>>
>> So this is a nonstarter.
> 
> Maybe call the sensor thing "dtsen" or something similarly short but not
> "dts"?
> 

Yeah, that's what we have to do.  Sigh.

	-hpa

