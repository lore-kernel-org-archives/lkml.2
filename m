Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1DKSCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:02:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62774 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1DKSCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cZvampN+zigyt1bPWCWOBDIxgxlkDUth/I50Z06dz08jpbgOOw0iqKSb9RtkYZGmyt
         RquAgjMCk0/9rdSbR9iBaiyeOZji5VsbkFj11k5+SPtfUEwKymotFTiHEeaBYieJuirY
         i4i+Wr/WVllGtMHwY9PGsC2GXyU9WahKCgh8Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTinKYvA6+xcBtDyg5hpHst2rxwW7tA@mail.gmail.com>
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
 <4DA33F3A.6090707@gmail.com> <BANLkTinKuQ7i20FxmDCT1cRMPvOxM0aygQ@mail.gmail.com>
 <BANLkTinKYvA6+xcBtDyg5hpHst2rxwW7tA@mail.gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Mon, 11 Apr 2011 19:02:11 +0100
Message-ID: <BANLkTikxTH-Nve=ixp=noipAnETxN9RFrg@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo

On Mon, Apr 11, 2011 at 18:59, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> On Mon, Apr 11, 2011 at 18:49, Xose Vazquez Perez
>> <xose.vazquez@gmail.com> wrote:
>>> On 04/11/2011 04:27 PM, Larry Finger wrote:
>>>
>>>> From: Shiang Tu<shiang_tu@ralinktech.com>
>>>>
>>>> Update firmware for rt2800pci to Version 34 and firmware for rt2800usb to
>>>> Version 29.
>>>>
>>>> Signed-off-by: Shiang Tu<shiang_tu@ralinktech.com>
>>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>> ---
>>>>  WHENCE     |    8 ++++----
>>>>  rt2860.bin |  Bin 8192 ->  8192 bytes
>>>>  rt2870.bin |  Bin 4096 ->  8192 bytes
>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> links to rt3070.bin rt3071.bin rt3090.bin ???
>>
>> there are no such files in current rt2x00 drivers.
>>
>> the rt2870.bin should support all USB rt2800 based chipsets with
>> several firmware blocks concatenated inside the file.
>> same goes for rt2860, which support all PCI rt2800 based chipsets with
>> several firmware blocks concatenated inside the file.
>
> Only USB uses concatenation to support multiple chipsets, for PCI
> we have a single file that is written into the device.
>
> Ivo
>

I stand corrected!

Luis Correia
