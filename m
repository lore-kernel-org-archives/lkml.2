Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2GISiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:38:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52330 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2GISiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX_aC1hzKf1eRqoSsQ4oALBev8p77v7++aoB2KrkOUaEw@mail.gmail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
	<1341784614-2797-12-git-send-email-dh.herrmann@googlemail.com>
	<CAMuHMdX_aC1hzKf1eRqoSsQ4oALBev8p77v7++aoB2KrkOUaEw@mail.gmail.com>
Date: Mon, 9 Jul 2012 20:38:17 +0200
Message-ID: <CANq1E4RyFpqxH=uG+dDA1=kfc3r8rCoEesZ31op9rCLjxyk6mQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] MAINTAINERS: add fblog entry
From: David Herrmann <dh.herrmann@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        florianschandinat@gmx.de, linux-fbdev@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        bonbons@linux-vserver.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert

On Mon, Jul 9, 2012 at 9:33 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sun, Jul 8, 2012 at 11:56 PM, David Herrmann
> <dh.herrmann@googlemail.com> wrote:
>> Add myself as maintainer for the fblog driver to the MAINTAINERS file.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
>> ---
>>  MAINTAINERS | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ae8fe46..249b02a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2854,6 +2854,12 @@ F:       drivers/video/
>>  F:     include/video/
>>  F:     include/linux/fb.h
>>
>> +FRAMEBUFFER LOG DRIVER
>> +M:     David Herrmann <dh.herrmann@googlemail.com>
>> +L:     linux-serial@vger.kernel.org
>
> Why linux-serial, and not linux-fbdev?

I thought fbcon was maintained on linux-serial as it is very related
to the vt/tty layer. If linux-fbdev is the better place, I can move
this. I CC'ed both lists, anyway.
I have actually no idea where it fits in best.

Thanks
David
