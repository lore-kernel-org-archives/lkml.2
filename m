Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1DKR5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:57:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35785 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1DKR5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MuxyEiSKLEKRG0L2kXcSSmPvXHNfskAFkKh4QNVXVZmDo+2t/dF9T6yaVtji3qgBnX
         U7Y9lRaaJZnVJjjf/h2uAZjX9bv8GCgyom+YCwnr9Qdq/FeH25Xqj7OXVXAw12jDbYOj
         VpVzR/K0AAu6o9c39CscUxu24+NAOT0quRuSs=
MIME-Version: 1.0
In-Reply-To: <4DA33F3A.6090707@gmail.com>
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
	<4DA33F3A.6090707@gmail.com>
Date: Mon, 11 Apr 2011 19:57:15 +0200
Message-ID: <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        users@rt2x00.serialmonkey.com, ben@decadent.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

What do you mean? Those files should be deleted from the linux-firmware
package. There is no need to keep them around, as with the removal of
the staging drivers, the last users of those files are gone.

Ivo
