Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1KXQOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:14:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34501 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab1KXQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+NV+Vkog3M6BMC9iMAdCJPbsDQUvPJx1ucsX5FV=kHJLu+ryw@mail.gmail.com>
References: <CA+NV+Vkog3M6BMC9iMAdCJPbsDQUvPJx1ucsX5FV=kHJLu+ryw@mail.gmail.com>
Date: Thu, 24 Nov 2011 18:14:12 +0200
Message-ID: <CACVxJT8D_9T+N8siZBGMccjUTeyip5YxNPg_jFTjpE4Bwb+CLA@mail.gmail.com>
Subject: Re: [path] adding header info in raw.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Rahul Bedarkar <rpal143@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 1:09 PM, Rahul Bedarkar <rpal143@gmail.com> wrote:
> --- a/include/linux/raw.h
> +++ b/include/linux/raw.h
> @@ -1,3 +1,9 @@
> +/*
> +* include/linux/raw.h
> +*
> +* include file for raw block device drivers
> +*/

Quite a useless comment.
Filename inside file especially.
