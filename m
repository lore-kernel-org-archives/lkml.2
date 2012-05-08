Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2EHPuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:50:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57525 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab2EHPuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:50:22 -0400
Message-ID: <4FA94051.3000307@zytor.com>
Date: Tue, 08 May 2012 08:48:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        glommer@redhat.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user change
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-8-git-send-email-alex.shi@intel.com> <1336489894.16236.51.camel@twins> <4FA939B9.6000404@zytor.com> <20120508152516.GF13568@aftab.osrc.amd.com> <4FA93C69.3050905@zytor.com> <20120508154150.GG13568@aftab.osrc.amd.com>
In-Reply-To: <20120508154150.GG13568@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 08:41 AM, Borislav Petkov wrote:
> On Tue, May 08, 2012 at 08:31:53AM -0700, H. Peter Anvin wrote:
>> On 05/08/2012 08:25 AM, Borislav Petkov wrote:
>>>
>>> Yep, this was supposed to be for pinpointing the proper entries count.
>>> I believe we don't have this thing of having code intree but not really
>>> intree - only for testing new silicon. Maybe a debug module or add this
>>> to debugfs?
>>>
>>
>> We have a lot of that kind of code, it is usually hidden under
>> CONFIG_*DEBUG* something.
> 
> Then maybe this is where this knob should go, along with adding it to
> debugfs instead of sysfs...
> 

I don't see a problem with it in sysfs.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

