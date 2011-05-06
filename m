Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1EFWYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:24:15 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:35996 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1EFWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:24:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPBzxE1bdWOb/2dsb2JhbACnFcYDhgkEj1iOVg
X-IronPort-AV: E=Sophos;i="4.64,328,1301868000"; 
   d="scan'208";a="755397410"
Message-ID: <4DC475A9.8070701@igalia.com>
Date: Sat, 07 May 2011 00:26:49 +0200
From: =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: sm7xx: Use kernel framebuffer mode setting
References: <1304702696-9403-1-git-send-email-jmunhoz@igalia.com> <20110506212207.GA3222@kroah.com>
In-Reply-To: <20110506212207.GA3222@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2011 11:22 PM, Greg KH wrote:
> On Fri, May 06, 2011 at 07:24:56PM +0200, Javier M. Mellid wrote:
>> This patch implements dynamic framebuffer mode setting.
>>
>> Previous code works with mode setting in a hard code way. Previous hard
>> code configuration is used as default configuration if dynamic mode
>> setting or boot mode setting (via sm712vga_setup) is not used.
>>
>> Tested with SM712 supporting 1024x600x16 as default hardware resolution.
>>
>> Changes:
>>
>> - Implement fb_check_var and fb_set_par callbacks
>> - Remove __maybe_unused decorator in function being used (sm712vga_setup)
>> - Minor cleanup on initialization structs related with mode settings
>> - Updated author copyright
>> - Updated TODO file
>>
>> Signed-off-by: Javier M. Mellid<jmunhoz@igalia.com>
>> ---
>>   drivers/staging/sm7xx/TODO     |    1 -
>
> This applies with fuzz, this leads me to believe that you didn't test
> this on the latest linux-next tree, right?
>
> What did you make this patch against?

Sorry, I didn't know. I made this patch against
linux-2.6 (bfd412db9e7b0d8f7b9c09d12d07aa2ac785f1d0) as I did with 
previous patches.

Testing was about creating, applying, compiling and running patch with 
kernel built from linux-2.6

Do you need a new patch against linux-next's master? I can redo this patch.

Sorry for the inconvenience.

javi
