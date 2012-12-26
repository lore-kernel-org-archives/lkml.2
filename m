Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2LZCYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:24:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2LZCYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:24:53 -0500
Message-ID: <50DA5FF0.2010300@lwfinger.net>
Date: Tue, 25 Dec 2012 20:24:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Champion Chen <champion_chen@realsil.com.cn>
Subject: Re: [PATCH] rtk_btusb: Add Bluetooth firmware
References: <1356057465-15669-1-git-send-email-Larry.Finger@lwfinger.net> <1356477982.21837.93.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1356477982.21837.93.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 05:26 PM, Ben Hutchings wrote:
> On Thu, 2012-12-20 at 20:37 -0600, Larry Finger wrote:
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Signed-off-by: Champion Chen <champion_chen@realsil.com.cn>
>> ---
>>   WHENCE              |    8 ++++++++
>>   rtl_bt/rtl8723a.bin |  Bin 0 -> 23772 bytes
>>   2 files changed, 8 insertions(+)
>>   create mode 100644 rtl_bt/rtl8723a.bin
>>
>> diff --git a/WHENCE b/WHENCE
>> index 3b2f282..f485111 100644
>> --- a/WHENCE
>> +++ b/WHENCE
>> @@ -1811,6 +1811,14 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
>>
>>   --------------------------------------------------------------------------
>>
>> +Driver: rtk_btusb - Realtek Bluetooth driver
>> +
>> +Info: Supplied by champion_chen@realsil.com.cn along with driver source code
>> +File: rtl_bt/rtl8723a.bin
>> +
>> +Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
> [...]
>
> There seem to be some serious problems with the driver that uses this.
> So, if this is not already in use with an external firmware blob, could
> you perhaps add some sort of header to the blob and have the driver make
> some sanity checks before uploading to the device?

Yes, I will add a header and the necessary checking. At that point, I will then 
resubmit.

Larry


