Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0DZN3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:29:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DZN26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:28:58 -0400
Message-ID: <4BD594E2.8030603@oracle.com>
Date: Mon, 26 Apr 2010 06:28:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Brian Swetland <swetland@google.com>
CC: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
References: <1271984938-13920-1-git-send-email-arve@android.com>	 <1271984938-13920-2-git-send-email-arve@android.com>	 <1271984938-13920-3-git-send-email-arve@android.com>	 <1271984938-13920-4-git-send-email-arve@android.com>	 <1271984938-13920-5-git-send-email-arve@android.com>	 <1271984938-13920-6-git-send-email-arve@android.com>	 <20100423135853.478af057.randy.dunlap@oracle.com>	 <20100425181517.GA22676@kroah.com> <4BD49D9D.7020004@oracle.com> <p2xa55d774e1004252324i4dca8cc3y1ffacec838c436f8@mail.gmail.com>
In-Reply-To: <p2xa55d774e1004252324i4dca8cc3y1ffacec838c436f8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BD594EA.018F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/10 23:24, Brian Swetland wrote:
> On Sun, Apr 25, 2010 at 12:53 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On 04/25/10 11:15, Greg KH wrote:
>>> On Fri, Apr 23, 2010 at 01:58:53PM -0700, Randy Dunlap wrote:
>>>> On Thu, 22 Apr 2010 18:08:54 -0700 Arve Hj?nnev?g wrote:
>>>>
>>>>> Report active and inactive suspend blockers in
>>>>> /sys/kernel/debug/suspend_blockers.
>>>>
>>>>
>>>> This looks more like user interface information than it does debug information.
>>>> If that's correct, it shouldn't be in debugfs.
>>>
>>> It's debug-like information, and has more than one value per file, so
>>> debugfs seems like the proper place for it.  I have no objection to it
>>> going there.
>>
>> I have no objection if it really is debug info, but I'm not convinced
>> of that yet.
> 
> Our most common use of this information is to capture it in bugreports
> (along with process lists, system/radio logs, memory stats, etc) as
> one additional piece of data used to diagnose a misbehaving device
> (most commonly to answer the "why does the battery seem to be draining
> too quickly?" question).

OK, thanks for the info.  Sounds good (i.e., it is debug info).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
