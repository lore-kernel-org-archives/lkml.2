Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2CUDtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 23:49:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43342 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2CUDtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 23:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203202340160.15617@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
	<20120320154159.GD27051@google.com>
	<Pine.LNX.4.64.1203202045150.23255@file.rdu.redhat.com>
	<Pine.LNX.4.64.1203202233250.6371@file.rdu.redhat.com>
	<CACBanvrjZbDY+aUUyp9-YuG8KoEd9k-cn50kn8N=3DQxKf7QFA@mail.gmail.com>
	<Pine.LNX.4.64.1203202340160.15617@file.rdu.redhat.com>
Date: Tue, 20 Mar 2012 20:49:37 -0700
X-Google-Sender-Auth: JC7Ovb2DpLUwhwJNE7234ukF2Lc
Message-ID: <CACBanvqYb3MU=Zy7HNJ2oMekQE6FZY5ZtN7QAaAv0M=tVH=cXw@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] dm: remake of the verity target
From: Mandeep Singh Baines <msb@chromium.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Elly Jones <ellyjones@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 8:44 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Tue, 20 Mar 2012, Mandeep Singh Baines wrote:
>
>> But we are hashing fixed-sized blocks so there is no possibility of extension.
>
> If the first part of some block contains some security-sensitive data and
> the last part of the same block can be attacker-controlled, he can use the
> collision attack to change the security-sensitive data.
>
>> However, better safe than sorry. I guess we'll just have to deal with
>> backward incompatibility. So feel free to add my sign off to the new
>> patch also.
>>
>> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
>>
>> Regards,
>> Mandeep
>>
>> > Mikulas
>
> I can introduce a switch to make it accept the old format. Do you want to?
>

We can carry that as an out-of-tree patch until we migrate.

On the other hand, it might be nice to support prepend or append.

I don't too strong feelings but it might be nice to have
prepend/append flag. Would definitely make our life easier.

> Mikulas
