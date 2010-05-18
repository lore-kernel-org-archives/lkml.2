Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0ERFlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:41:32 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:60983 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab0ERFlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lyf9kiqctGD44lCqm2Fc5dFO1/DXHScx8jCgNlsjDdBqEC6B+W+ybBLZdbxAEj9Jdd
         fnkZZw7WaL/t18FnFjLanQ2uAngk0giI9Kkgy3hDgI6iddlQcR1K/6JSyyvfOqCordIc
         6CUk6iXrMWesrNSh+UsNxGjENfml/p6yb3Iak=
MIME-Version: 1.0
In-Reply-To: <20100518052230.GA1706@amit-laptop.redhat.com>
References: <AANLkTilW8zZxCOrdiefZ4ZtixprI58LzDZ6Cz03z4lFk@mail.gmail.com>
	 <20100518052230.GA1706@amit-laptop.redhat.com>
Date: Tue, 18 May 2010 13:41:29 +0800
Message-ID: <AANLkTimXLkzb-CyhbkOaubAOiSsIkGKW0y5Cblrwfvst@mail.gmail.com>
Subject: Re: [PATCH] fix a code style in drivers/char/virtio_console.c
From: Steven Liu <lingjiujianke@gmail.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Amit,

    if 'err' initialised in this path, it needn't do err = -ENOMEM
after,isn't it?



Best regards


2010/5/18 Amit Shah <amit.shah@redhat.com>:
> On (Tue) May 18 2010 [13:17:22], Steven Liu wrote:
>> fix a code style in drivers/char/virtio_console.c
>>
>> Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
>
> NACK.
>
> This style is deliberate and follows Rusty's style: if we end up using
> 'err' uninitialised in some code path, it can get flagged by source
> checkers.
>
>                Amit
>
