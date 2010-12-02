Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0LBSO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:14:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0LBSOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pWuSQU7zVzibzmyQgg8bZQD/3GWmmHufZtUk2xzJGa8QOiaGwnryk1Wr5mlsYHw8qy
         ngbWrpBFXCFnXS+ph4m/4Trn9y7nISKvfwXgEIfkMl2jM0Ae0nmYdLtgwnZlFNzWWSId
         Jd/4MvoyGUGAZU72qSZfcopwLPJ0PxVbo9s3s=
Date: Thu, 2 Dec 2010 19:14:04 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Charles Manning <cdhmanning@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Add yaffs2 file system: allocator, attribs, bitmap
 code
Message-ID: <20101202181344.GA2853@joi.lan>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
 <1291154254-22533-2-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291154254-22533-2-git-send-email-cdhmanning@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:57:27AM +1300, Charles Manning wrote:
> +void yaffs_load_current_time(struct yaffs_obj *obj, int do_a, int do_c)
> +{
> +	obj->yst_mtime = Y_CURRENT_TIME;
                 ^
> +	if (do_a)
> +		obj->yst_atime = obj->yst_atime;
                         ^                ^
> +	if (do_c)
> +		obj->yst_ctime = obj->yst_atime;
                         ^                ^
> +}
> +

Funny bug.

Marcin

