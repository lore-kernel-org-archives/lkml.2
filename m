Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1LECQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:16:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1LECQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:16:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAKnK67SDyFCbLjpwzY9JQiBHJTgpF9uXOq+GUBW7oWv_5gZzbA@mail.gmail.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
	<1322817178-8931-5-git-send-email-ming.lei@canonical.com>
	<CAKnK67SDyFCbLjpwzY9JQiBHJTgpF9uXOq+GUBW7oWv_5gZzbA@mail.gmail.com>
Date: Mon, 5 Dec 2011 10:16:32 +0800
Message-ID: <CACVXFVMW0FaAMYJ3rdqtwsK9HGBwcd5gW0TTG_ix=+7TH1yfsw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/7] media: videobuf2: introduce VIDEOBUF2_PAGE memops
From: Ming Lei <ming.lei@canonical.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 3, 2011 at 12:35 AM, Aguirre, Sergio <saaguirre@ti.com> wrote:
> Hi Ming,
>> diff --git a/include/media/videobuf2-page.h b/include/media/videobuf2-page.h
>> new file mode 100644
>> index 0000000..29b3e20
>> --- /dev/null
>> +++ b/include/media/videobuf2-page.h
>> @@ -0,0 +1,20 @@
>> +/*
>> + * videobuf2-vmalloc.h - vmalloc memory allocator for videobuf2
>> + *
>> + * Copyright (C) 2010 Samsung Electronics
>> + *
>> + * Author: Pawel Osciak <pawel@osciak.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation.
>> + */
>> +
>> +#ifndef _MEDIA_VIDEOBUF2_VMALLOC_H
>> +#define _MEDIA_VIDEOBUF2_VMALLOC_H
>
> Copy-paste much? :)

Yes, will fix it in next version, :-)

thanks,
--
Ming Lei
