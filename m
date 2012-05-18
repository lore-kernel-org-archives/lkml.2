Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab2ERGWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:22:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38428 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2ERGWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16F64F8527E@NWD2CMBX1.ad.analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-4-git-send-email-sonic.zhang@analog.com>
	<CAM=Q2cta_a2XcOLoOnnUUjZOpj1phUH99xfgZnh4nhxG8QX3-Q@mail.gmail.com>
	<DB904C5425BA6F4E8424B3B51A1414D16F64F8527E@NWD2CMBX1.ad.analog.com>
Date: Fri, 18 May 2012 11:52:41 +0530
Message-ID: <CAM=Q2ctYVmok6bJu4kRWM2CX07vp7NS0VTHyeVzbJa3TttLU2Q@mail.gmail.com>
Subject: Re: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing I2C
 transfer if MEN bit is reset unexpectedly.
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 8:11 AM, Zhang, Sonic <Sonic.Zhang@analog.com> wrote:
>
>
>>-----Original Message-----
>>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>>Sent: Thursday, May 17, 2012 7:31 PM
>>To: Zhang, Sonic
>>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>>devel@blackfin.uclinux.org
>>Subject: Re: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing I2C
>>transfer if MEN bit is reset unexpectedly.
>>
>>On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>
>>> Correct I2C transfer may fail because interrupt status bits XMTSERV and
>>> RCVSERV are not checked when MCOMP interrupt is handled.
>>>
>>Could you expand MCOMP?
>
> Master transfer complete (MCOMP)
> [1] The initiated master transfer has completed. In the absence of a
> repeat start, the bus has been released.
> [0] The completion of a transfer has not been detected.
>

A trivial suggestion may be the changelog could be enhanced.
Thanks for the explanation.

>
> Regards,
>
> Sonic
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
