Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1HUWgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:36:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59349 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1HUWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:36:26 -0400
Date: Sun, 21 Aug 2011 18:36:17 -0400
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>, bookjovi@gmail.com
Cc: dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7LMakNQ017989

Concur.  The comment should be changed
Neil

Oleg Nesterov <oleg@redhat.com> wrote:

>On 08/21, Oleg Nesterov wrote:
>>
>> On 08/21, bookjovi@gmail.com wrote:
>> >
>> > For non-pipe case, limit 0 also means drop the coredump, so just put
>> > the zero limit check at do_coredump function begining.
>>
>> Neil, what do you think? Should we change the code or the comment?
>
>Personally I think we should fix the comment. I think RLIMIT_CORE
>doesn't apply in this case, limit == 1 check is very special. And
>this is what linux always did, except between 725eae32 and 898b374a.
>
>
>Oleg.
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
