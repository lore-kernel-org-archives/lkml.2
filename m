Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1DKSkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:40:18 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3565 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab1DKSkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:40:16 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 14:40:16 EDT
Message-ID: <4DA3477F.8080709@gmail.com>
Date: Mon, 11 Apr 2011 20:25:03 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b13pre) Gecko/20110314 Thunderbird/3.3a3
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net> <4DA33F3A.6090707@gmail.com> <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com> <20110411181303.GD2268@decadent.org.uk>
In-Reply-To: <20110411181303.GD2268@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Apr 2011 18:25:04.0386 (UTC) FILETIME=[C7022620:01CBF875]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 20:13, Ben Hutchings wrote:
> On Mon, Apr 11, 2011 at 07:57:15PM +0200, Ivo Van Doorn wrote:
>>>> From: Shiang Tu<shiang_tu@ralinktech.com>
>>>>
>>>> Update firmware for rt2800pci to Version 34 and firmware for rt2800usb to
>>>> Version 29.
>>>>
>>>> Signed-off-by: Shiang Tu<shiang_tu@ralinktech.com>
>>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>> ---
>>>>  WHENCE     |    8 ++++----
>>>>  rt2860.bin |  Bin 8192 ->  8192 bytes
>>>>  rt2870.bin |  Bin 4096 ->  8192 bytes
>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> links to rt3070.bin rt3071.bin rt3090.bin ???
>>
>> What do you mean? Those files should be deleted from the linux-firmware
>> package. There is no need to keep them around, as with the removal of
>> the staging drivers, the last users of those files are gone.
>  
> Stop repeating this nonsense, Ivo.  If the firmware has been bundled in
> the Linux tree, that would be correct.  For linux-firmware the policy is
> different.

It's unbelievable how much fuzz a set of binary firmware files can create.

To be honest, I do not care whether they stay or go, as long as it is very
clear that rt2x00 does not need, and will never need those files. If they
stay, I would recommend simply not touching them at all, and leave them as
they are, so that nothing changes for the people running the staging driver
(at least with respect to these 3 firmware files).

Larry, it might be best to update your changes to the WHENCE file to clearly
state that these 3 files are only needed for the staging rt2860sta driver,
up to kernel 2.6.39 (assuming that that staging driver will be removed in 2.6.40).

---
Gertjan
