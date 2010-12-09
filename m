Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0LIOFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:05:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:59314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab0LIOFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:05:20 -0500
Message-ID: <4D00E212.9080001@kernel.org>
Date: Thu, 09 Dec 2010 15:05:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 000/211] unicore32 architecture support
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <4D00A672.9050906@kernel.org> <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 14:05:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 02:49 PM, Thomas Gleixner wrote:
>> * Patches should be split according to logical steps of changes, not
>>   per-file.
>>
>> * Patches should be bisectable.  IOW, after applying upto any patch in
>>   the series, the tree should be buildable and working.
> 
> That does not work for a new architecture. There is nothing to bisect.

Sure, but at least it shouldn't introduce build scripts first which
wouldn't work at all.

>> * When posting a patch series, especially one as large as 211, please
>>   make the mails for the actual patches replies to the head message.
>>   Don't post it as 212 separate messages or replies to the immediate
>>   previous patch.
>>
>> So, in short, if you're adding a whole new arch, just post it as a
>> single patch or a series of several patches if it requires changes
>> outside of the specific arch subtree.
> 
> Crap. a single patch is a major PITA for review. It's even worse than
> 211 per file patches.

Cut the crap.  A single patch may not be perfect for reviewing but
archs are often merged as a single giant patch as bisection is
meaningless anyway.

-- 
tejun
