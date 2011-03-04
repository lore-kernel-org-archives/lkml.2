Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab1CDEHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:07:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43987 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab1CDEHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:07:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iPpZA8Rv3fYcfFtvuUP2DvqWOyV6eHPwlZ6qx+P9Qy87tJtrxqYUuARS+O1taMm8ot
         N/QvkFKVfeI3Y5ROR7+EycjCF5szPwFbaCE84yt+jvjZHBluwQDrB6YMP6m48uGxdPae
         MSSs64P1FEHbo84kGAbIaCydDwb/j1Aa41Gts=
MIME-Version: 1.0
In-Reply-To: <201103021731.01598.toralf.foerster@gmx.de>
References: <201103021731.01598.toralf.foerster@gmx.de>
Date: Fri, 4 Mar 2011 12:07:39 +0800
Message-ID: <AANLkTimUnPxWK2YUpBX=ZT-g63eiXrQkL9p54SQwQGVz@mail.gmail.com>
Subject: Re: checkpatch.pl: never finishes w/ specific file
From: Jovi Zhang <bookjovi@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: akpm@linux-foundation.org, apw@canonical.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/3 Toralf Förster <toralf.foerster@gmx.de>:
> Hello,
>
> this runs infinitely :
>
> ./scripts/checkpatch.pl --file ./drivers/staging/rtl8192u/r819xU_firmware_img.c
>
> Is this a known behaviour of checkpatch.pl  ?
>

Not infinitely, just need to wait for a long time.

checkpatch.pl works fine, it report like this:

ERROR: space required after that ',' (ctx:VxV)

+0x01,0x00,0x00,0x08,0x00,0x00,0x00,0x00,};
                        ^

That file miss so many whitespace after ',' from checkpatch point of view.
Anyway, forget it, checkpatch.pl is not recommended to check those files.
