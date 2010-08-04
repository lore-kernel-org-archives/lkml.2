Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0HDXKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:10:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:24101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab0HDXJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,317,1278313200"; 
   d="scan'208";a="593027212"
Message-ID: <4C59F343.20901@linux.intel.com>
Date: Wed, 04 Aug 2010 16:09:55 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: bifferos <bifferos@yahoo.co.uk>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what
 c_ident is
References: <279129.36717.qm@web27001.mail.ukl.yahoo.com>
In-Reply-To: <279129.36717.qm@web27001.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 03:59 PM, bifferos wrote:
> --- On Wed, 4/8/10, H. Peter Anvin <hpa@linux.intel.com> wrote:
> 
>>
>> Incidentally, please do note that there is no concrete
>> benefit to this
>> "support", since all it does is replicate information in
>> /proc/cpuinfo
>> that is already available through lspci.
> 
> Without the patch RDC is misreported as Cyrix Cx486SLC.
> 

And what problems does that cause?  Presumably none, in which case you
have to realize that the correctness threshold for this patch is
enormous, as the benefit is extremely small compared with the potential
(and actual!) harm.

	-hpa
