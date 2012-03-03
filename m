Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2CCGD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 01:03:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:56927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2CCGD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 01:03:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124500101"
Message-ID: <4F51B425.7090805@intel.com>
Date: Sat, 03 Mar 2012 14:03:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: jeremy@goop.org, "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC patch] cmpxchg_double: remove local variables to get better
 performance
References: <1330677063.21053.1532.camel@debian> <4F5098B80200007800075F33@nat28.tlf.novell.com> <1330678843.21053.1553.camel@debian> <4F509CE30200007800075F84@nat28.tlf.novell.com> <4F50E376.3030000@intel.com> <4F50F594020000780007612D@nat28.tlf.novell.com>
In-Reply-To: <4F50F594020000780007612D@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 11:30 PM, Jan Beulich wrote:

>>>> On 02.03.12 at 16:12, Alex Shi <alex.shi@intel.com> wrote:
>> On 03/02/2012 05:11 PM, Jan Beulich wrote:
>>> In particular, requiring an L suffix here on literals should be avoided.
>>
>>
>> Even the each macro may save 0x40 bytes text, and bring more 10%
>> execution speed?
> 
> Again - if you see meaningful text size differences with optimization
> properly enabled, this may need investigation at the compiler end.


Yes, you are right.
I take back this patch.

> 
> Jan
> 


