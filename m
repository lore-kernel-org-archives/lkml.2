Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2JWGrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:47:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48113 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2JWGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
	<001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
Date: Tue, 23 Oct 2012 08:47:18 +0200
Message-ID: <CANGUGtDLAQxjiRgFDhJww1j7qSEshvJbHFKaD_QwmjyK9rBBmQ@mail.gmail.com>
Subject: Re: [PATCH 02/16 v2] f2fs: add on-disk layout
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/23 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> This adds a header file describing the on-disk layout of f2fs.
>
> Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> Signed-off-by: Chul Lee <chur.lee@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  include/linux/f2fs_fs.h |  362 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 362 insertions(+)
>  create mode 100644 include/linux/f2fs_fs.h
>
> diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> new file mode 100644
> index 0000000..bd9c217
> --- /dev/null
> +++ b/include/linux/f2fs_fs.h
> @@ -0,0 +1,362 @@
> +/**
> + * include/linux/f2fs_fs.h

Is this file used by user space?

> + *
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _LINUX_F2FS_FS_H
> +#define _LINUX_F2FS_FS_H
> +
> +#include <linux/pagemap.h>
> +#include <linux/types.h>
> +
> +#define F2FS_SUPER_MAGIC       0xF2F52010

In magic.h please.

Marco
