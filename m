Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab0DXEyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 00:54:31 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:39281 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0DXEya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 00:54:30 -0400
MIME-Version: 1.0
In-Reply-To: <4BD27266.8070900@oracle.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-2-git-send-email-arve@android.com>
	 <1271984938-13920-3-git-send-email-arve@android.com>
	 <1271984938-13920-4-git-send-email-arve@android.com>
	 <1271984938-13920-5-git-send-email-arve@android.com>
	 <1271984938-13920-6-git-send-email-arve@android.com>
	 <20100423135853.478af057.randy.dunlap@oracle.com>
	 <n2rd6200be21004232023hf138c65dia5b378825124933d@mail.gmail.com>
	 <4BD27266.8070900@oracle.com>
Date: Fri, 23 Apr 2010 21:54:29 -0700
Message-ID: <x2sd6200be21004232154i4738d938vf57ade1b702cf404@mail.gmail.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/23 Randy Dunlap <randy.dunlap@oracle.com>:
> On 04/23/10 20:23, Arve Hjønnevåg wrote:
>> 2010/4/23 Randy Dunlap <randy.dunlap@oracle.com>:
>>> On Thu, 22 Apr 2010 18:08:54 -0700 Arve Hjønnevåg wrote:
>>>
>>>> Report active and inactive suspend blockers in
>>>> /sys/kernel/debug/suspend_blockers.
>>>
>>>
>>> This looks more like user interface information than it does debug information.
>>> If that's correct, it shouldn't be in debugfs.
>>
>> Where should it be? It is not allowed in sysfs, and procfs does not
>> appear to be open to new files.
>
> Why is it not allowed in sysfs?  due to more than one value per file

Yes.

> or something else?
>
> I don't think that procfs is closed to new files, but you may have to
> justify why it should be used.
>

I used procfs in the original version and there were a lot of
objections to this, so I moved it to debugfs.

-- 
Arve Hjønnevåg
