Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2GHJQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 05:16:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59274 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GHJQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 05:16:23 -0400
MIME-Version: 1.0
In-Reply-To: <4FF94689.3050701@computer.org>
References: <1341735405-16997-1-git-send-email-yamanetoshi@gmail.com>
	<4FF94689.3050701@computer.org>
Date: Sun, 8 Jul 2012 18:16:22 +0900
Message-ID: <CAOTypNQ=Kbz1oS30AjjSA-svNuv_-H=Nkm+xfQNS3G8BQUHgjg@mail.gmail.com>
Subject: Re: [PATCH] Fix checkpatch.pl issue.
From: yamanetoshi <yamanetoshi@gmail.com>
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: greg@kroah.com, sjakub@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree.

On Sun, Jul 8, 2012 at 5:36 PM, Jan Ceuleers <jan.ceuleers@computer.org> wrote:
> On 07/08/2012 10:16 AM, Toshiaki Yamane wrote:
>> -printk(KERN_ERR, to pr_err(...
>>
>> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
>
> Hi
>
> I submit that your subject line should be more descriptive. Perhaps
> something like the following:
>
> [PATCH] asus_oled: Use pr_err(...) rather than printk(KERN_ERR ...)
>
> The rest of your commit message could then clarify that this change was
> inspired by checkpatch.
>
> HTH, Jan



-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com
