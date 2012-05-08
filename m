Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2EHPWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:22:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57228 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab2EHPWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:22:05 -0400
Message-ID: <4FA939B9.6000404@zytor.com>
Date: Tue, 08 May 2012 08:20:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alex Shi <alex.shi@intel.com>, mgorman@suse.de, npiggin@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        gregkh@linuxfoundation.org, glommer@redhat.com, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user change
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>  <1336485790-30902-8-git-send-email-alex.shi@intel.com> <1336489894.16236.51.camel@twins>
In-Reply-To: <1336489894.16236.51.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 08:11 AM, Peter Zijlstra wrote:
> On Tue, 2012-05-08 at 22:03 +0800, Alex Shi wrote:
>> kernel will replace cr3 rewrite with invlpg when
>> 	tlb flush entries <= 1/tlb_flushall_factor
>> if tlb_flushall_factor is 0, kernel won't do this replace.
>>
>> User can modify its value according to specific applications.
> 
> Yay!, another useless config knob :-(
> 

I think this one is mostly for benchmarking new silicon to find out the
proper value, I'm guessing?

	-hpa

