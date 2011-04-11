Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1DKR4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:56:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34799 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab1DKR4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pdmxUORs5srNgyX829lesg3nzEXiHhsIMAn3nBtsUYRG200qcTvU8Mo92B6qQvgCle
         Ey7q36QceppHIo1BKPH/XSjrj3hfm1T5EVJx7rgHDbuA3OU2PqM+xsoQ0L5jWFkjfX2d
         m1fiQ0gGQxXSoksswcvfD5hJUDvk3slAHQc9o=
MIME-Version: 1.0
In-Reply-To: <4DA33F3A.6090707@gmail.com>
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net> <4DA33F3A.6090707@gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Mon, 11 Apr 2011 18:55:30 +0100
Message-ID: <BANLkTinKuQ7i20FxmDCT1cRMPvOxM0aygQ@mail.gmail.com>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, gwingerde@gmail.com, ben@decadent.org.uk,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Shiang Tu <shiang_tu@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Apr 11, 2011 at 18:49, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On 04/11/2011 04:27 PM, Larry Finger wrote:
>
>> From: Shiang Tu<shiang_tu@ralinktech.com>
>>
>> Update firmware for rt2800pci to Version 34 and firmware for rt2800usb to
>> Version 29.
>>
>> Signed-off-by: Shiang Tu<shiang_tu@ralinktech.com>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
>>  WHENCE     |    8 ++++----
>>  rt2860.bin |  Bin 8192 ->  8192 bytes
>>  rt2870.bin |  Bin 4096 ->  8192 bytes
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> links to rt3070.bin rt3071.bin rt3090.bin ???

there are no such files in current rt2x00 drivers.

the rt2870.bin should support all USB rt2800 based chipsets with
several firmware blocks concatenated inside the file.
same goes for rt2860, which support all PCI rt2800 based chipsets with
several firmware blocks concatenated inside the file.

we know that this is confusing, we've had to live with it for a loooong time.


Luis Correia
rt2x00 project admin
