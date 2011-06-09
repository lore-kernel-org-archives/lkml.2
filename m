Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1FIBC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:02:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59706 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1FIBC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EjuJW+ntaj/pyYD4lrWzl8gf6h5//vo3bKZQpgJlt0L5O2IDRHKJ+hkg/NbtnVOpI2
         7hrEX/rV1deUK6v3HUa/6/oLnyJ80KZd6U/Fm6UOBcy7V5mfpNamCQxIaKBbw+1OQ10I
         ixu2gVQo91D2T0YZiG/6llG6OIDgqYsplcjWQ=
MIME-Version: 1.0
In-Reply-To: <20110609105930.8bef6aaa.sfr@canb.auug.org.au>
References: <4DE0B9D8.3020405@gmail.com>
	<4DE10B4D.50501@gmail.com>
	<4DEE56AF.1040601@gmail.com>
	<4DEFD2F4.5000403@gmail.com>
	<20110609105930.8bef6aaa.sfr@canb.auug.org.au>
Date: Thu, 9 Jun 2011 09:02:55 +0800
Message-ID: <BANLkTin-v-b0WPHQP-k1uZZcE+QDreweVw@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] ramoops: use module parameters instead of platform
 data if not available
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        stevie.trujillo@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Marco,
>
> On Wed, 08 Jun 2011 21:52:21 +0200 Marco Stornelli <marco.stornelli@gmail.com> wrote:
>>
>> Il 07/06/2011 18:49, Marco Stornelli ha scritto:
>> > From: Marco Stornelli<marco.stornelli@gmail.com>
>> >
>> > Use generic module parameters instead of platform data, if platform
>> > data are not available. This limitation has been introduced with
>> > commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
>> >
>> > Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
>> > CC: Kyungmin Park<kyungmin.park@samsung.com>
>> > CC: Américo Wang<xiyou.wangcong@gmail.com>
>> > Reported-by: Stevie Trujillo<stevie.trujillo@gmail.com>
>> > ---
>>
>> can you add this patch and "[PATCH 2/2 v3] ramoops: add a new line for
>> each print" to the linux-next? Thanks.
>
> I don't know what "this patch" is.  Also, I don't add patches to
> linux-next normally, they should all come through some tree that has been
> included in linux-next.
>

Right, the patch should be merged into some tree first, in this case,
I think Andrew Morton will take it.

Thanks.
