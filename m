Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0JLXbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 19:31:52 -0400
Received: from mail.candelatech.com ([208.74.158.172]:51036 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0JLXbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 19:31:51 -0400
Message-ID: <4CB4EFD4.6020209@candelatech.com>
Date: Tue, 12 Oct 2010 16:31:32 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode
 in debugfs"
References: <20101012163519.a88f2040.sfr@canb.auug.org.au> <1286895206-3030-1-git-send-email-linville@tuxdriver.com> <AANLkTi=Rj+hmYthVcwYksSxUqFF+117FxVvdnuDCLxVY@mail.gmail.com> <20101012181804.GC2403@tuxdriver.com>
In-Reply-To: <20101012181804.GC2403@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 11:18 AM, John W. Linville wrote:
> On Tue, Oct 12, 2010 at 11:13:31AM -0700, Linus Torvalds wrote:
>> On Tue, Oct 12, 2010 at 7:53 AM, John W. Linville
>> <linville@tuxdriver.com>  wrote:
>>>
>>> Please don't make me commit such an ugly patch...
>>
>>   Why don't you just create a dummy inline ath_opmode_to_string() that
>> returns NULL in the non-debug case? The compiler will make the
>> conditionals all go away, and it will end up being "UNKNOWN" which is
>> just what you want. No?
>
> Shhh!  Your messing-up my manipulative mind games! :-)

Looks like this was my bug, and I lost these emails in a folder
I don't read so often.

If you're not happy with the fixes posted, let me know and
I'll work on one.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

