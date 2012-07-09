Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2GIXfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:35:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45878 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2GIXfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120709193329.GA13214@kroah.com>
References: <1341739547-17254-1-git-send-email-yamanetoshi@gmail.com>
	<20120709193329.GA13214@kroah.com>
Date: Tue, 10 Jul 2012 08:35:05 +0900
Message-ID: <CAOTypNQoq6j_jTx3cyT3JU-+aafhDfX7M6kKU3YN4dzVeT0YGg@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] asus_oled: Use pr_err(...) rather than
 printk(KERN_ERR ...)
From: yamanetoshi <yamanetoshi@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: sjakub@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem :-)

On Tue, Jul 10, 2012 at 4:33 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Jul 08, 2012 at 06:25:47PM +0900, Toshiaki Yamane wrote:
>> This change is inspired by checkpatch.
>>
>> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/asus_oled/asus_oled.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> Sorry, someone beat you to this very change by a few hours :(
>
> greg k-h



-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com
