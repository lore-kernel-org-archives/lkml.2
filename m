Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2D3TgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:36:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63317 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2D3TgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:36:03 -0400
Message-ID: <4F9EE99F.1010204@gmail.com>
Date: Mon, 30 Apr 2012 12:35:59 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH NEXT]staging: rtl8192u Fix typos.
References: <4F9ED6D3.6060405@lwfinger.net> <4F9ED82D.1050204@lwfinger.net>
In-Reply-To: <4F9ED82D.1050204@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 11:21 AM, Larry Finger wrote:
> On 04/30/2012 01:15 PM, Larry Finger wrote:
>> From: "Justin P. Mattock" <justinmattock@xxxxxxxxx>
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@xxxxxxxxx>
>>
>> ---
>>
>> The below patch fixes some typos that I found while going through
>> staging/rtl8192u
>>
>> drivers/staging/rtl8192u/r8180_93cx6.c | 2 +-
>> drivers/staging/rtl8192u/r8180_93cx6.h | 2 +-
>> drivers/staging/rtl8192u/r8192U.h | 6 +-
>> drivers/staging/rtl8192u/r8192U_core.c | 56 ++++++++++++++--------------
>> drivers/staging/rtl8192u/r8192U_dm.c | 50 ++++++++++++------------
>> drivers/staging/rtl8192u/r8192U_hw.h | 2 +-
>> drivers/staging/rtl8192u/r8192U_wx.c | 8 ++--
>> drivers/staging/rtl8192u/r8192U_wx.h | 2 +-
>> drivers/staging/rtl8192u/r819xU_HTType.h | 2 +-
>> drivers/staging/rtl8192u/r819xU_cmdpkt.c | 8 ++--
>> drivers/staging/rtl8192u/r819xU_firmware.c | 4 +-
>> drivers/staging/rtl8192u/r819xU_phy.c | 16 ++++----
>> drivers/staging/rtl8192u/r819xU_phyreg.h | 2 +-
>> 13 files changed, 80 insertions(+), 80 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c
>> b/drivers/staging/rtl8192u/r8180_93cx6.c
>> index 8878cfe..0e8ff75 100644
>> --- a/drivers/staging/rtl8192u/r8180_93cx6.c
>> +++ b/drivers/staging/rtl8192u/r8180_93cx6.c
>> @@ -14,7 +14,7 @@
>>
>> Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
>>
>> - We want to tanks the Authors of those projects and the Ndiswrapper
>> + We want to thanks the Authors of those projects and the Ndiswrapper
> ======
>> project Authors.
>> */
>>
>
> Please do not introduce a new typo while "fixing" the old one.
> s/thanks/thank/ in several places.
>
> Note: I do not subscribe to LKML, thus I had to dummy in a reply and
> this message will likely not be threaded correctly.
>
> Larry
>


cool! Thank you for the info.. I will send out something that fixes the 
"thanks" as soon as I can.

Justin P. Mattock
