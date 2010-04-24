Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab0DXE03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 00:26:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39075 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0DXE02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 00:26:28 -0400
Message-ID: <4BD27266.8070900@oracle.com>
Date: Fri, 23 Apr 2010 21:24:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
References: <1271984938-13920-1-git-send-email-arve@android.com>	 <1271984938-13920-2-git-send-email-arve@android.com>	 <1271984938-13920-3-git-send-email-arve@android.com>	 <1271984938-13920-4-git-send-email-arve@android.com>	 <1271984938-13920-5-git-send-email-arve@android.com>	 <1271984938-13920-6-git-send-email-arve@android.com>	 <20100423135853.478af057.randy.dunlap@oracle.com> <n2rd6200be21004232023hf138c65dia5b378825124933d@mail.gmail.com>
In-Reply-To: <n2rd6200be21004232023hf138c65dia5b378825124933d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BD272C7.00FB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/10 20:23, Arve Hjønnevåg wrote:
> 2010/4/23 Randy Dunlap <randy.dunlap@oracle.com>:
>> On Thu, 22 Apr 2010 18:08:54 -0700 Arve Hjønnevåg wrote:
>>
>>> Report active and inactive suspend blockers in
>>> /sys/kernel/debug/suspend_blockers.
>>
>>
>> This looks more like user interface information than it does debug information.
>> If that's correct, it shouldn't be in debugfs.
> 
> Where should it be? It is not allowed in sysfs, and procfs does not
> appear to be open to new files.

Why is it not allowed in sysfs?  due to more than one value per file
or something else?

I don't think that procfs is closed to new files, but you may have to
justify why it should be used.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
