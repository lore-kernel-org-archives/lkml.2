Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0KCRLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:11:00 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16086 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0KCRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:10:57 -0400
Message-ID: <4CD197A1.4060600@caviumnetworks.com>
Date: Wed, 03 Nov 2010 10:10:57 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: cdhmanning@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/9] Add some yaffs include files
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-7-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1288803204-3849-7-git-send-email-cdhmanning@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2010 17:11:32.0575 (UTC) FILETIME=[29AEF6F0:01CB7B7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 09:53 AM, cdhmanning@gmail.com wrote:
> From: Charles Manning<cdhmanning@gmail.com>
>
> Adding yaffs2 file system.
>
> Signed-off-by: Charles Manning<cdhmanning@gmail.com>
> ---
>   fs/yaffs2/yaffs_guts.h  |  914 +++++++++++++++++++++++++++++++++++++++++++++++
>   fs/yaffs2/yaffs_trace.h |   58 +++
>   fs/yaffs2/yportenv.h    |   90 +++++
>   3 files changed, 1062 insertions(+), 0 deletions(-)
>   create mode 100644 fs/yaffs2/yaffs_guts.h
>   create mode 100644 fs/yaffs2/yaffs_trace.h
>   create mode 100644 fs/yaffs2/yportenv.h
>
> diff --git a/fs/yaffs2/yaffs_guts.h b/fs/yaffs2/yaffs_guts.h
> new file mode 100644
> index 0000000..60770ca
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_guts.h
> @@ -0,0 +1,914 @@
> +/*
> + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning<charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License version 2.1 as
> + * published by the Free Software Foundation.
> + *
> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> + */

What are the implications of putting LGPL things in the kernel?

I don't know, but someone probably should think about it.

David Daney
