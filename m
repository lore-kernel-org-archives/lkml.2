Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2LTAYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:24:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48378 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab2LTAYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:24:37 -0500
Message-ID: <50D25AA9.3090306@zytor.com>
Date: Wed, 19 Dec 2012 16:24:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
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
References: <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic> <50D24C25.5050604@zytor.com> <20121219234054.GA6130@jshin-Toonie> <50D252B6.6050802@zytor.com> <20121220000723.GB6130@jshin-Toonie>
In-Reply-To: <20121220000723.GB6130@jshin-Toonie>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 04:07 PM, Jacob Shin wrote:
> 
> From what I remember, accessing memory around the memory hole (not
> just the HT hole, but e038000000 ~ 10000000000 on our mentioned system
> ) generated prefetches because the memory hole was marked as WB in PAT.
> 
> I'll take a look at the system again, try the blanket MTRR covering
> 0xe000000000 ~ 1TB, and talk to our BIOS guys.
> 

Yes, but do they all #MC (as opposed to, say, fetching all FFs)?

	-hpa


