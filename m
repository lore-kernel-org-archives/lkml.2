Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2LTAPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:15:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48297 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2LTAPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:15:43 -0500
Message-ID: <50D25897.30001@zytor.com>
Date: Wed, 19 Dec 2012 16:15:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic> <50D24C25.5050604@zytor.com> <20121219234012.GO24895@liondog.tnic> <50D25591.4030302@zytor.com> <20121220001027.GQ24895@liondog.tnic>
In-Reply-To: <20121220001027.GQ24895@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 04:10 PM, Borislav Petkov wrote:
> On Wed, Dec 19, 2012 at 04:02:25PM -0800, H. Peter Anvin wrote:
>> The goal should be to have this into -tip and -next by the middle of
>> January in order to make the 3.9 merge window, I think.
>
> ...and an easy back-out strategy in case there are too many issues while
> testing. Maybe don't merge it into tip/master so that it can be removed
> easily, or something to that effect.
>

We keep everything in topic branches; tip:master is a synthetic branch 
which can be regenerated as needed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

