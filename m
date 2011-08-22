Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1HVIaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:30:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49623 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1HVI36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:29:58 -0400
Date: Mon, 22 Aug 2011 16:29:56 +0800
Subject: Re: [Doc] class_find_device: fix reference to argument
Message-ID: <j6kgp6ke33c16c8rk02opdej.1314001796855@email.android.com>
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7M8UBw0019560

no,not sure. but i think you are right.

Randy Dunlap <rdunlap@xenotime.net> wrote:

>On Sun, 21 Aug 2011 14:46:04 +0000 (UTC) Wanlong Gao wrote:
>
>> Rolf Eike Beer <eike <at> sf-mail.de> writes:
>> 
>> > 
>> > Signed-off-by: Rolf Eike Beer <eike-kernel <at> sf-tec.de>
>> > ---
>> >  drivers/base/class.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> > 
>> 
>> > - * @fn is allowed to do anything including calling back into class
>> > + * @match is allowed to do anything including calling back into class
>> >   * code.  There's no locking restriction.
>> >   */
>> >  struct device *class_find_device(struct class *class, struct device *start,
>> 
>> NACK, it means the function class_find_device but not the @match.
>
>Are you sure?  Looks to me like a comment that was copied from
>class_for_each_device() but shouldn't have been copied.
>
>Anyway, I'll cc: Greg to see if he knows.
>
>---
>~Randy
>*** Remember to use Documentation/SubmitChecklist when testing your code ***
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
