Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2LSX5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:57:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48139 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2LSX5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:57:48 -0500
Message-ID: <50D25464.6040007@zytor.com>
Date: Wed, 19 Dec 2012 15:57:24 -0800
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
References: <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic> <50D24C25.5050604@zytor.com> <20121219234054.GA6130@jshin-Toonie> <50D252B6.6050802@zytor.com> <20121219235537.GP24895@liondog.tnic>
In-Reply-To: <20121219235537.GP24895@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 03:55 PM, Borislav Petkov wrote:
> On Wed, Dec 19, 2012 at 03:50:14PM -0800, H. Peter Anvin wrote:
>> We are trying to discuss mitigation strategies with you, but you
>> haven't really given us any useful information, e.g. what happens near
>> the various boundaries of the hole, what could trigger prefeching into
>> the range, and what it would take to fix the BIOSes.
>
> Another thing we could do (I admit it is ugly) is to add a quirk to the
> #MC handler and detect that specific condition by looking at the address
> reported in MCi_ADDR and exit early by not panicking the system.
>
> Again, this is ugly but a possibility, still.
>

I would really, really hate to have to deal with an early MCE handler, too.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

