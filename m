Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0LVJAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:00:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0LVJAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:00:53 -0500
Message-ID: <4D11BE9A.3020609@cn.fujitsu.com>
Date: Wed, 22 Dec 2010 17:02:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4 V3 ] futex,plist: pass the real head of the priority
 list to plist_del()
References: <4D107979.2020405@cn.fujitsu.com> <4D10FC40.6070808@linux.intel.com> <4D11984A.5030203@cn.fujitsu.com> <4D119FA6.4070807@linux.intel.com>
In-Reply-To: <4D119FA6.4070807@linux.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-22 17:00:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-22 17:00:44,
	Serialize complete at 2010-12-22 17:00:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 02:50 PM, Darren Hart wrote:
> On 12/21/2010 10:18 PM, Lai Jiangshan wrote:
>> On 12/22/2010 03:13 AM, Darren Hart wrote:
>>> On 12/21/2010 01:55 AM, Lai Jiangshan wrote:
>>>
>>> Hi Lai,
>>>
>>> Looks about ready to me, only a couple of more nitpics from me.
>>>
>>
>> Fixed, thanks.
> 
> Looks good to me. How did the futextest runs go?
> 

It's OK, the result are almost the same.

kernel version: 2.6.37-rc6-tip
Intel(R) Pentium(R) D CPU 2.80GHz
MemTotal:         961208 kB

# diff result result.applied -u | grep '^[+-]'
--- result	2010-12-22 16:57:45.000000000 +0800
+++ result.applied	2010-12-22 16:56:39.000000000 +0800
-Result: 12048 Kiter/s
+Result: 12210 Kiter/s
-Result: 4037 Kiter/s
+Result: 3554 Kiter/s
-Result: 3331 Kiter/s
+Result: 3347 Kiter/s
-Result: 2996 Kiter/s
+Result: 3124 Kiter/s
-Result: 2998 Kiter/s
+Result: 3087 Kiter/s
-Result: 2894 Kiter/s
+Result: 3008 Kiter/s
-Result: 2863 Kiter/s
+Result: 2882 Kiter/s
-Result: 3098 Kiter/s
+Result: 3265 Kiter/s
-Result: 2888 Kiter/s
+Result: 2811 Kiter/s
-Result: 2876 Kiter/s
+Result: 2995 Kiter/s
-Result: 2893 Kiter/s
+Result: 2980 Kiter/s
-Result: 3100 Kiter/s
+Result: 2860 Kiter/s
-Result: 2915 Kiter/s
+Result: 2964 Kiter/s
-Result: 2940 Kiter/s
+Result: 3035 Kiter/s
-Result: 2671 Kiter/s
+Result: 2939 Kiter/s
