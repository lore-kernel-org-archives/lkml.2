Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946032Ab2EKSfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:35:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34178 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946015Ab2EKSft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:35:49 -0400
Message-ID: <4FAD5B87.6090809@zytor.com>
Date: Fri, 11 May 2012 11:33:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-2-git-send-email-alex.shi@intel.com> <4FAC0D1E.3000403@landley.net>
In-Reply-To: <4FAC0D1E.3000403@landley.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 11:46 AM, Rob Landley wrote:
> On 05/10/2012 12:00 AM, Alex Shi wrote:
>> Since sizeof(long) is 4 in x86_32 mode, and it's 8 in x86_64 mode,
>> sizeof(long long) is also 8 byte in x86_64 mode.
>> use long mode can fit TLB_FLUSH_ALL defination here both in 32 or
>> 64 bits mode.
> 
> I.E. Linux follows the LP64 standad, as do the BSDs and MacOS X:
> 
> http://www.unix.org/whitepapers/64bit.html
> http://www.unix.org/version2/whatsnew/lp64_wp.html
> 

Specifically, it is universally assumed in the Linux kernel that
sizeof(long) == sizeof(size_t) == sizeof(intptr_t).

	-hpa

