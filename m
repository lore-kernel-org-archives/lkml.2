Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2EJXyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:54:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2EJXyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:54:22 -0400
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com> <1336666614-21090-8-git-send-email-fenghua.yu@intel.com> <878ae68a-72cf-40cb-a654-a2c1cb3df0c3@email.android.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007715B10@ORSMSX105.amr.corp.intel.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122007715B10@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH v6 07/12] x86/head_32.S: Define start_cpu0
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 10 May 2012 18:53:08 -0500
To: "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Message-ID: <554807c7-739e-4d5a-befc-34bf86399d75@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just meant: please check if there are any conflicts .. 

"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

>> -----Original Message-----
>> From: H. Peter Anvin [mailto:hpa@zytor.com]
>> Sent: Thursday, May 10, 2012 10:31 AM
>> To: Yu, Fenghua; Ingo Molnar; Thomas Gleixner; Linus Torvalds; Andrew
>> Morton; Mallick, Asit K; Luck, Tony; Arjan Dan De Ven; Siddha, Suresh
>B;
>> Brown, Len; Srivatssa S. Bhat; Randy Dunlap; Chen Gong; linux-kernel;
>> linux-pm; x86
>> Subject: Re: [PATCH v6 07/12] x86/head_32.S: Define start_cpu0
>> 
>> Can you check how this interacts with tip:x86/realmode?
>
>When CPU0 is waken up by NMI, it's in protect mode and jumps to
>start_cpu0() which only sets up stack and goes to initial_code. CPU0
>wake up doesn't go through trampline and starts from real mode. This is
>different from waking up AP when AP goes through INIT/STARTUP sequence
>and starts from real mode.
>
>Thanks.
>
>-Fenghua

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
