Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0EGUdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:33:33 -0400
Received: from mga10.intel.com ([192.55.52.92]:12725 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995Ab0EGUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,350,1270450800"; 
   d="scan'208";a="796465520"
Message-ID: <4BE4791B.1060304@linux.intel.com>
Date: Fri, 07 May 2010 13:33:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com> <4BE478C1.2060602@zytor.com>
In-Reply-To: <4BE478C1.2060602@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2010 13:32, H. Peter Anvin wrote:
>
> I really wish I knew the exact systems affected by the HLT bug.  If I
> remember correctly, it was some 386 systems -- or possibly 486 systems
> as well -- a very long time ago.  This test just provides a diagnosis if
> the system really is bad (it hangs with an obvious message) at the cost
> of some 40 ms to the system boot time.  I suspect C1 (HLT) being broken
> is not anywhere close to the predominant power management problem in the
> current day, and as such I'm wondering if this particular test hasn't
> outlived its usefulness.
>
> Thoughts?

we could at least hide it behind the "don't run on pentium or newer" config options..
