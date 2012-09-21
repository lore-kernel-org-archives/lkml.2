Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2IUQOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:14:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43783 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2IUQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:14:17 -0400
Message-ID: <505C9254.5090101@lwfinger.net>
Date: Fri, 21 Sep 2012 11:14:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Jan Terstegge <jan@terstegge.net>
Subject: Re: [PATCH] rtlwifi/rtl8712u Revert firmware
References: <1347294365-6509-1-git-send-email-Larry.Finger@lwfinger.net> <1348180259.4801.9.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1348180259.4801.9.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 05:31 PM, Ben Hutchings wrote:
> On Mon, 2012-09-10 at 11:26 -0500, Larry Finger wrote:
>> Although the newest firmware for the RTL8192SU, which is found in vendor
>> driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404, works with most
>> devices, it causes drops of the wireless connection for the ASUS WL-167G V3
>> (USB ID 0b05:1791), the D-Link DWA131 (07d1:3303), and probably others.
>> Tests show that the firmware from vendor driver
>> rtl8712_8188_8191_8192SU_usb_linux_v7_0.20100831 works better.
>>
>> This commerts reverts to that older firmware.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> [...]
>
> This is the original blob added by:
>
> commit 8f919160792e4702c6b7a67a243cea4f757407e4
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Mon Nov 1 23:56:52 2010 -0500
>
>      linux-firmware: Add firmware files for Realtek RTL8712U and RTL8192CE
>
> There have been two updates since then:
>
> commit f8ddc05e13c4c6dd9d725bc376b287f307eb223a
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Tue Aug 16 11:12:14 2011 -0500
>
>      rtlwifi: rtl8712u: Upgrade to firmware found in vendor's V2.6.6
>
> commit d8f60751d3f09545f51aac5d8e451f7668063ebf
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Wed Jul 11 13:18:30 2012 -0500
>
>      r8712u: Update to latest firmware
>
>      A new firmware file is used in the vendor driver with name/version
>      rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404.
>
> Sure you want to revert both of these, not just the latest?

Yes. Both of the updates work on my hardware (D-Link and Rosewill), but both 
fail on an ASUS WL-167g v3 as reported privately to me. I will work with Realtek 
and the OP to resolve the problem, and then update the fw once again.

Thanks,

Larry


