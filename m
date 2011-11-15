Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1KOXsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:48:10 -0500
Received: from asix.com.tw ([113.196.140.82]:63213 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab1KOXsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:48:09 -0500
From: "allan" <allan@asix.com.tw>
To: "'Grant Grundler'" <grundler@chromium.org>,
        "'David Miller'" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <freddy@asix.com.tw>
References: <1321377163-26308-1-git-send-email-grundler@chromium.org>	<20111115.164134.1813312136000862195.davem@davemloft.net> <CANEJEGt3iR1q-2200L1gAYhha4uatPKRche5dAS4bzSVm5bjTA@mail.gmail.com>
In-Reply-To: <CANEJEGt3iR1q-2200L1gAYhha4uatPKRche5dAS4bzSVm5bjTA@mail.gmail.com>
Subject: RE: [PATCH 1/5] net-next:asix:PHY_MODE_RTL8211CL should be 0xC
Date: Wed, 16 Nov 2011 07:47:50 +0800
Message-ID: <002501cca3f0$ffe1fa20$ffa5ee60$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acyj5hBowSvH50hRToSbjpsMnpbs6gACn7Zw
Importance: High
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Grant and Dave,

Thanks a lot for your great helps to submit/approve these asix.c driver patches onto Linux kernel mainline source. Please feel free to let us know if you have any problems or need any helps from us. Thanks a lot. 

Have a good days!


---
Best regards,
Allan Chou
Technical Support Division
ASIX Electronics Corporation
TEL: 886-3-5799500 ext.228
FAX: 886-3-5799558
E-mail: allan@asix.com.tw 
http://www.asix.com.tw/ 

-----Original Message-----
From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
Sent: Wednesday, November 16, 2011 6:27 AM
To: David Miller
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; allan@asix.com.tw; freddy@asix.com.tw
Subject: Re: [PATCH 1/5] net-next:asix:PHY_MODE_RTL8211CL should be 0xC

On Tue, Nov 15, 2011 at 1:41 PM, David Miller <davem@davemloft.net> wrote:
> From: Grant Grundler <grundler@chromium.org>
> Date: Tue, 15 Nov 2011 09:12:39 -0800
>
>> From: Grant Grundler <grundler@google.com>
>>
>> Use correct value for rtl phy support.
>> (rtl phy are in AX88178 devices like NWU220G and USB2-ET1000).
>>
>> Signed-off-by: Allan Chou <allan@asix.com.tw>
>> Tested-by: Grant Grundler <grundler@chromium.org>
>
> Applied.

Dave,
Thanks for applying the series and offering to push immediately to
linus. I'll submit the white space/coding style clean ups after the
frustration of my blooper has receded from your memory a bit more. :)

cheers,
grant

