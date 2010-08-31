Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0HaPDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:03:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1084 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab0HaPDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:03:46 -0400
Subject: Re: [PATCH 1/1] MAINTAINERS: remove isicom
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com
In-Reply-To: <1283246395-16624-1-git-send-email-jslaby@suse.cz>
References: <4C7CC90C.2030100@suse.cz>
	 <1283246395-16624-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 08:03:44 -0700
Message-ID: <1283267024.1797.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 11:19 +0200, Jiri Slaby wrote:
> I do not maintain isicom anymore...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  MAINTAINERS |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e24eb2d..8bab6f3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3923,12 +3923,6 @@ S:	Maintained
>  F:	Documentation/sound/oss/MultiSound
>  F:	sound/oss/msnd*
>  
> -MULTITECH MULTIPORT CARD (ISICOM)
> -M:	Jiri Slaby <jirislaby@gmail.com>
> -S:	Maintained
> -F:	drivers/char/isicom.c
> -F:	include/linux/isicom.h
> -
>  MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
>  M:	Felipe Balbi <felipe.balbi@nokia.com>
>  L:	linux-usb@vger.kernel.org

Perhaps it's better to remove your name
and set the status to Orphan instead.


