Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab2JLTtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:49:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33130 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2JLTtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:49:10 -0400
Message-ID: <50787432.8030805@lwfinger.net>
Date: Fri, 12 Oct 2012 14:49:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Spurious warning in checkpatch.pl?
References: <5078603C.9010709@lwfinger.net> <1350067114.2243.35.camel@joe-AO722>
In-Reply-To: <1350067114.2243.35.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 01:38 PM, Joe Perches wrote:
> On Fri, 2012-10-12 at 13:23 -0500, Larry Finger wrote:
>> Andy,
>>
>> The checkpatch.pl version in mainline is issuing what I think are false warnings
>> of the type
>>
>> WARNING: networking block comments put the trailing */ on a separate line
>> #93: FILE: drivers/net/wireless/rtlwifi/wifi.h:208:
>> +       u32 rf_rb;              /* rflssi_readback */
>>
>> Is a trailing comment for the member of a struct not allowed?
>
> It's allowed.  Maybe even better, encouraged.
>
> It's a change I made in commit 058806007450
> ("checkpatch: check networking specific block comment style")
> without sufficient testing.
>
> I'll see about fixing it.

Joe,

Good. I will ignore those warnings.

One more question. Was the warning below intended?

WARNING: networking block comments put the trailing */ on a separate line
#1846: FILE: drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h:27:
+ *****************************************************************************/

To me, that line at the end of a copyright block looks better then


  ****************************************************************************
  */

Larry



