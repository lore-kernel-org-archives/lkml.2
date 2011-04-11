Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1DKR7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:59:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63279 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab1DKR73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kpyHf6HoK0UnQZ9SAfe3Uxr4Jw68lGwxlZM+WouATZKVZB7Etwuh4BhqnvHrtmvQh2
         36qloyRKqmFpbuej3U/mQl4OaXUQa71Dq4N4OVq4LVr6L0QTThtAK3+Hnr0vqRFuqebu
         IFHI1yFpbMtEdtGZuM8uCioRuS23ism25R4Vc=
MIME-Version: 1.0
In-Reply-To: <BANLkTinKuQ7i20FxmDCT1cRMPvOxM0aygQ@mail.gmail.com>
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
	<4DA33F3A.6090707@gmail.com>
	<BANLkTinKuQ7i20FxmDCT1cRMPvOxM0aygQ@mail.gmail.com>
Date: Mon, 11 Apr 2011 19:59:28 +0200
Message-ID: <BANLkTinKYvA6+xcBtDyg5hpHst2rxwW7tA@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Mon, Apr 11, 2011 at 18:49, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:
>> On 04/11/2011 04:27 PM, Larry Finger wrote:
>>
>>> From: Shiang Tu<shiang_tu@ralinktech.com>
>>>
>>> Update firmware for rt2800pci to Version 34 and firmware for rt2800usb to
>>> Version 29.
>>>
>>> Signed-off-by: Shiang Tu<shiang_tu@ralinktech.com>
>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>> ---
>>>  WHENCE     |    8 ++++----
>>>  rt2860.bin |  Bin 8192 ->  8192 bytes
>>>  rt2870.bin |  Bin 4096 ->  8192 bytes
>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> links to rt3070.bin rt3071.bin rt3090.bin ???
>
> there are no such files in current rt2x00 drivers.
>
> the rt2870.bin should support all USB rt2800 based chipsets with
> several firmware blocks concatenated inside the file.
> same goes for rt2860, which support all PCI rt2800 based chipsets with
> several firmware blocks concatenated inside the file.

Only USB uses concatenation to support multiple chipsets, for PCI
we have a single file that is written into the device.

Ivo
