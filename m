Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2FKG2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:28:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44810 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2FKG2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <4FD48317.50706@ontolinux.com>
References: <4FD46521.5070900@gmail.com>
	<4FD48317.50706@ontolinux.com>
Date: Mon, 11 Jun 2012 08:28:20 +0200
Message-ID: <CANGUGtBjH+gfSkNtkfb91zziodBvyejpB3D7emNnFwUj8ZB=wQ@mail.gmail.com>
Subject: Re: [PATCH 00/17] pramfs: persistent and protected RAM filesystem
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/10 Christian Stroetmann <stroetmann@ontolinux.com>:
> On Sun, June 10, 2012 Marco Stornelli wrote:
>>
>> Hi all,
>>
>> after the merge of pramfs in the LTSI kernel and after the "hot topic" NVM
>> Mapping API, here a new submission of pramfs code. Even if the code won't be
>> in mainline the review is really useful to me, so any comment is welcome.
>
> Hello
>
> I think we have here two cases:
> 1. "A block of non-volatile RAM separate for normal system memory",
> [documentation Pramfs] and
> 2. The whole RAM is non-volatile and so the whole situation is changed, and
> an NVM Mapping API is needed and "hotly" discussed.
>
> For 1. your solution is a very good concept that is getting around issues
> solely related with specific optimizations for disc-based file systems, like
> the 2 problems described in the documentation of Pramfs, but
> for 2. there is no need for a file system anymore, as we use it today while
> working with a computer system, because data needs not to be written to a
> file system at all, and so the file system will become something like a
> backup system in the most common use cases of a computing device, if I
> should describe it a little bit too provocative. In this case your approach
> taken to handle the 2 problems mentioned in the documentation of Pramfs
> would have to be driven further by focusing more on the management of the
> RAM, the power, and the long-term data storage (backup) for harmonizing
> Pramfs with them. A further point is to make Pramfs bootable, if this not
> already possible somehow.
>

I have to say that this submission doesn't want to be a complete
answer to the "NVM Mapping API", no way, but eventually only part of
the solution. Pramfs was bootable, but the support was removed,
however the modification would be easy.

Marco
