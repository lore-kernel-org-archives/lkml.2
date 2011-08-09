Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1HIWAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 18:00:17 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:36140 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1HIWAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 18:00:15 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1312927212!27954986!12
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Date: Tue, 9 Aug 2011 17:00:11 -0500
Subject: RE: gpio-ep93xx: Add helper function to convert irq to gpio, port,
 and mask.
Thread-Topic: gpio-ep93xx: Add helper function to convert irq to gpio, port,
 and mask.
Thread-Index: AcxW3c0LsW0Fg9eFQDOWhRdm3nOdhwAAYyKg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3883894A4@AUSP01VMBX24.collaborationhost.net>
References: <201108091104.14053.hartleys@visionengravers.com>
 <4E41AB23.4080209@gmail.com>
In-Reply-To: <4E41AB23.4080209@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p79M0kgJ000306

On Tuesday, August 09, 2011 2:48 PM, Ryan Mallon wrote:
> On 10/08/11 04:04, H Hartley Sweeten wrote:
>> This consolidates the irq_to_gpio() call and the shift magic used to convert
>> a GPIO irq into it's relevant GPIO, port, and mask values.
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>
> I think this should have my:
>
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
>
> Since I wrote the original patch.

Sorry, misunderstood your previous email.

I re-coded this patch based on my one helper function instead of your two
functions.  Regardless, the idea was yours and I have no problem with it
having your Signed-off-by.

I'll re-post it with the modified sign offs shortly.

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
