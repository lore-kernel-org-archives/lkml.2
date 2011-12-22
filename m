Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1LVAJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:09:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab1LVAJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:09:08 -0500
Message-ID: <4EF27517.6010609@zytor.com>
Date: Wed, 21 Dec 2011 16:08:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrf.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading
 v3
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <1324338394-4670-8-git-send-email-andi@firstfloor.org> <201112211203.26153.trenn@suse.de> <20111221201227.GA9262@alboin.amr.corp.intel.com> <4EF23E41.40608@zytor.com> <20111221213009.GA2568@redhat.com> <20111222000142.GA10955@alboin.amr.corp.intel.com>
In-Reply-To: <20111222000142.GA10955@alboin.amr.corp.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 04:01 PM, Andi Kleen wrote:
>> A synthetic one is pointless, because you'd just be duplicating something
>> similar to the above in generic code that would need updating for every new stepping.
> 
> powernow-k8 uses two mechanisms: family/models and on newer CPUs like
> Fam15 a CPUID bit.  Just not in the standard leaves. This would
> not need to be updated.
> 

So this should be:

1. added to the scattered CPUID features list;
2. artificially set in the AMD-specific initialization code for the
older CPUs.

	-hpa

