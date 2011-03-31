Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab1CaS3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:29:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57998 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939Ab1CaS3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:29:54 -0400
Message-ID: <4D94C7B4.4070904@zytor.com>
Date: Thu, 31 Mar 2011 11:28:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-1.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com> <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com> <20110331061247.GA24786@elte.hu> <alpine.LFD.2.02.1103310252160.8569@x980> <20110331081800.GH5938@elte.hu> <alpine.LFD.2.02.1103311336320.9662@x980>
In-Reply-To: <alpine.LFD.2.02.1103311336320.9662@x980>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 11:07 AM, Len Brown wrote:
>>
>> Do we know whether a distro adds this to the boot line? Do we know about users 
>> relying on it.
> 
> Impossible to know.
> 

The first would be insanely unlikely, as the machines with HLT problems
were already getting old by the time Linux distributions started
appearing in significant numbers.

Users relying on it is another issue.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

