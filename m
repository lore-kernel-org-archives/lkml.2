Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1GYUVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:21:03 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41005 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1GYUUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:20:49 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Mihai Moldovan <ionic@ionic.de>
Cc: Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix fat utf8 iocharset warning message
References: <4E2C2015.6090200@ionic.de>
	<alpine.LNX.2.00.1107241921350.5758@swampdragon.chaosbits.net>
	<4E2C6220.5070706@ionic.de>
Date: Tue, 26 Jul 2011 05:20:46 +0900
In-Reply-To: <4E2C6220.5070706@ionic.de> (Mihai Moldovan's message of "Sun, 24
	Jul 2011 20:19:12 +0200")
Message-ID: <87fwlukt7l.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mihai Moldovan <ionic@ionic.de> writes:

> * On 24.07.2011 07:22 PM, Jesper Juhl wrote:
>> @@ -1190,7 +1190,7 @@ out:
>>      if (!strcmp(opts->iocharset, "utf8")) {
>>          fat_msg(sb, KERN_ERR, "utf8 is not a recommended IO charset"
>> Is KERN_ERR really the right thing to use here? 
>> Sounds more like a warning to me..
>
> I'm interested to see what Ogawa says, but I'd say KERN_WARNING would be
> better here as well, yeah.

I agree to change it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
