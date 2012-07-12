Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2GLGgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:36:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44347 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2GLGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <1342071788.1970.18.camel@joe2Laptop>
References: <1342060541-9648-1-git-send-email-yamanetoshi@gmail.com>
	<4FFE5F0F.8020904@gmail.com>
	<1342071788.1970.18.camel@joe2Laptop>
Date: Thu, 12 Jul 2012 15:36:22 +0900
Message-ID: <CAOTypNS6Ztj6w1ybYBgte5NoTf8mO_9_rHqBTiicmg53O-r_xg@mail.gmail.com>
Subject: Re: [PATCH v3] panel: Use pr_err(...) rather than printk(KERN_ERR ...)
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>, Joe Perches <joe@perches.com>
Cc: greg@kroah.com, willy@meta-x.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan-san, Joe-san,

Thanks for your advice.
I will try re-create the patch again.

On Thu, Jul 12, 2012 at 2:43 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-07-12 at 15:22 +1000, Ryan Mallon wrote:
>> On 12/07/12 12:35, Toshiaki Yamane wrote:
>> > This change is inspired by checkpatch.
>>
>> Your changelog needs to describe all of the changes you are making. The
>> subject line only describes one. This patch is doing the following:
>>
>>  - Converting printk(KERN_ERR to pr_err
>>  - Adding __func__ prefixes to printk lines
>>  - Refactoring split printk strings onto a single line
>>
>> There are a few other printks in this file which could be converted to
>> pr_* to make the code more consistent. Perhaps a follow up patch?
>>
>> Typically for a sub-sequent version of a patch/series you should list
>> the changes since the last round. Put these below the --- so that they
>> don't become part of the change log, e.g.:
>>
>>   Signed-off-by: Your name/email here
>>   ---
>>
>>   Changes since v2:
>>     - Some stuff
>>
>>   Changes since v1:
>>     - Some other stuff
>>
>> Some more comments below.
>
> And ideally cc the people that gave you notes/comments
> on your previous patches too.
>



-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com
