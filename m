Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965935Ab0GPQDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:03:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51230 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965834Ab0GPQDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:03:05 -0400
Message-ID: <4C408298.8060004@zytor.com>
Date: Fri, 16 Jul 2010 09:02:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
References: <20100713185816.2866.17837.stgit@localhost.localdomain> <20100713185957.2866.50995.stgit@localhost.localdomain> <20100714160704.GA10473@kryptos.osrc.amd.com> <20100714232201.00433aa9@hammerfall> <20100714233102.0f64614b@hammerfall> <4C3FDF43.6030203@zytor.com> <20100716063952.GB27546@aftab> <4C3F8418.5020803@zytor.com> <20100716072244.GA27954@aftab>
In-Reply-To: <20100716072244.GA27954@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 12:22 AM, Borislav Petkov wrote:
>>
>> No, the difference between using a separate variable and the CPU feature 
>> bit is that CPU feature bit is ANDed across all CPUs, whereas this 
>> variable is set if it is set on *any* CPU.
> 
> ... and that's ok because the MSR bits get set on all cores after BIOS
> turns on C1E. Let me verify this though.
> 

Is there any reason for the OR behavior?  Otherwise, it's just plain
wrong...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

