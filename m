Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1FIGqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:46:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43300 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1FIGqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VDVVju4kIbWZrAEtXqxZ5c4RjCjpCqydnz2e4456uWVr3ksgABuNfBjhH7btu0p6O4
         GA3Y+JZxhIXybXaEwA5Ax4NzT208HptV62o004/sxpN6JAGfSvKwPD4oF5FcbZhLDn14
         Q3v0lV/A9yD5eRTtpJJR8UGFmai4AVO8WfAKE=
MIME-Version: 1.0
In-Reply-To: <BANLkTin-v-b0WPHQP-k1uZZcE+QDreweVw@mail.gmail.com>
References: <4DE0B9D8.3020405@gmail.com>
	<4DE10B4D.50501@gmail.com>
	<4DEE56AF.1040601@gmail.com>
	<4DEFD2F4.5000403@gmail.com>
	<20110609105930.8bef6aaa.sfr@canb.auug.org.au>
	<BANLkTin-v-b0WPHQP-k1uZZcE+QDreweVw@mail.gmail.com>
Date: Thu, 9 Jun 2011 08:46:50 +0200
Message-ID: <BANLkTikN4NpxRpHR2aEERE5RT-r9i8joUA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] ramoops: use module parameters instead of platform
 data if not available
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        stevie.trujillo@gmail.com,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/9 Américo Wang <xiyou.wangcong@gmail.com>:
> On Thu, Jun 9, 2011 at 8:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Marco,
>>
>> On Wed, 08 Jun 2011 21:52:21 +0200 Marco Stornelli <marco.stornelli@gmail.com> wrote:
>>>
>>> Il 07/06/2011 18:49, Marco Stornelli ha scritto:
>>> > From: Marco Stornelli<marco.stornelli@gmail.com>
>>> >
>>> > Use generic module parameters instead of platform data, if platform
>>> > data are not available. This limitation has been introduced with
>>> > commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
>>> >
>>> > Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
>>> > CC: Kyungmin Park<kyungmin.park@samsung.com>
>>> > CC: Américo Wang<xiyou.wangcong@gmail.com>
>>> > Reported-by: Stevie Trujillo<stevie.trujillo@gmail.com>
>>> > ---
>>>
>>> can you add this patch and "[PATCH 2/2 v3] ramoops: add a new line for
>>> each print" to the linux-next? Thanks.
>>
>> I don't know what "this patch" is.  Also, I don't add patches to
>> linux-next normally, they should all come through some tree that has been
>> included in linux-next.
>>
>
> Right, the patch should be merged into some tree first, in this case,
> I think Andrew Morton will take it.
>
> Thanks.
>

Hi Andrew,

can you add these patches into your tree? Thanks.

Regards,

Marco
