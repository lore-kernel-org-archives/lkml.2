Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1AVPbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:31:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1AVPbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nz/kT970zc+7PxgaZIVpTw9e79ztUgTVZJI1xivGHB9OFZn+5VZIzJJHDMyt8DDyn8
         /1GdrfTdZxP3XLggGGRK2wCB3lfAwsREcIEnOBgY8PnmUswNKDc5bN8qvyHtL4AIHG7d
         27XwyiuxzoyWZ1ENaL/2SkqXqj2RdDF0FBhSc=
MIME-Version: 1.0
In-Reply-To: <20110122150315.GA26270@p183.telecom.by>
References: <20110122150315.GA26270@p183.telecom.by>
Date: Sat, 22 Jan 2011 15:31:19 +0000
Message-ID: <AANLkTi=TOo=u+wz7GEDZfPnOoV3VywOrf46yPK7wLykT@mail.gmail.com>
Subject: Re: [PATCH] headers: remove aio.h from sched.h
From: Will Newton <will.newton@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 3:03 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -26,6 +26,7 @@
>  #include <linux/cdrom.h>
>  #include <linux/slab.h>
>  #include <linux/times.h>
> +#include <linux/uio.h>
>  #include <asm/uaccess.h>
>
>  #include <scsi/scsi.h>

Should this be aio.h?

There's a few more instances of uio,h elsewhere in the patch.
