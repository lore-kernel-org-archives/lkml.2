Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1HQNWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:22:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43209 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1HQNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:22:09 -0400
Message-ID: <4E4BC07D.3030305@monstr.eu>
Date: Wed, 17 Aug 2011 15:22:05 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>	 <1313071035-12047-13-git-send-email-matt@console-pimps.org>	 <20110816172010.GC29190@redhat.com> <20110816172049.GD29190@redhat.com>	 <4E4BBB8D.5020307@monstr.eu> <1313587077.2311.18.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1313587077.2311.18.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:
> On Wed, 2011-08-17 at 15:01 +0200, Michal Simek wrote:
>> Oleg Nesterov wrote:
>>> On 08/16, Oleg Nesterov wrote:
>>>> This and the next patch seem to have the same problems with the
>>>> changelogs as 18 and 19.
>>>>
>>>> 13-14 looks correct to me...
>>> I meant 14-15, sorry for noise
>> Do you mean that there is
>> From: Matt Fleming <matt.fleming@intel.com> ?
>>
>> Anyway: I have looked at patches 12-15 and they look good to me.
>>
>> Fix that "From:" line and you can add my
> 
> What's wrong with the From: line? That should be fine. Oleg was saying
> that the description in the changelog needed updating.

It is just additional information but I see when you apply it with git-am it is not there.
That's fine.

Fix what Oleg described and let me know if you want to add to Microblaze tree.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
