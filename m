Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1H2OWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:22:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56083 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1H2OWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <4E5B9CB0.4090708@ladisch.de>
References: <20110829122320.GX13925@legolas.emea.dhcp.ti.com>
	<1314621110-19367-1-git-send-email-balbi@ti.com>
	<CABb+yY15qrszsbJSGGFra7mrVRO_oQPUhNT=U7TNpyoYikABPw@mail.gmail.com>
	<4E5B9CB0.4090708@ladisch.de>
Date: Mon, 29 Aug 2011 19:52:09 +0530
Message-ID: <CABb+yY1aQtN2fHKDk9a1MoAra40PSg3kotUJMhGJt8sb7EqTgA@mail.gmail.com>
Subject: Re: [PATCH v2] sound: usb: mixer: increase control transfer timeout
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Felipe Balbi <balbi@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7TEMJdl018281

On Mon, Aug 29, 2011 at 7:35 PM, Clemens Ladisch <clemens@ladisch.de> wrote:

>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  buf, val_len, 1000) >= val_len) {
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  buf, val_len, 1000) >= 0) {
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  !value, 0, NULL, 0, 1000);
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  !value, 0, NULL, 0, 1000);
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  value, index + 2, NULL, 0, 1000);
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  jacks[i].unitid << 8, buf, 3, 1000);
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  50, 0, &new_status, 1, 1000);
>>
>> How about also converting to use a local define for timeout value ?
>
> ... now that _all_ calls to snd_usb_ctl_msg use the same timeout value,
> we could just as well drop this parameter.
Sounds better, esp when we have 9 arguments to snd_usb_ctl_msg!
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
