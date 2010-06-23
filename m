Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0FWWyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:54:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44518 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0FWWyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BjYLP45Xm18pd7QmmxAE8+fkV0xOx/bS593oSKKzWBkH/q0jw8zt3xS/kr1PeVwCmR
         898Rl1Zv+7l3EAoiw7zQ4vUw1X3bvlYfXAhsWnSVTOWvAlUUmztrPHDEwa927m+Zkjnq
         STp3t3lyNktQ7DaZou2MEoIOwxp+eC5XzIMwo=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH] MAINTAINERS: Add an entry for the input MT protocol
Date: Wed, 23 Jun 2010 15:54:45 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1277330664-13884-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1277330664-13884-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006231554.46440.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 23, 2010 03:04:24 pm Henrik Rydberg wrote:
> This patch adds a maintainer for the input multitouch (MT) protocol,
> such that get_maintainer.pl selects it whenever an MT event is present
> in the patch.
> 
> Cc: Joe Perches <joe@perches.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d119c9..32157c8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3858,6 +3858,13 @@ S:	Maintained
>  F:	drivers/char/isicom.c
>  F:	include/linux/isicom.h
> 
> +MULTITOUCH INPUT MT PROTOCOL

Should we call the section "INPUT MULTITOUCH (MT) PROTOCOL" and move
it closer to the main INPUT section so that if anyone looks in MAINTAINERS
directly they'd see both entries? 

> +M:	Henrik Rydberg <rydberg@euromail.se>
> +L:	linux-input@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/input/multi-touch-protocol.txt
> +K:	ABS_MT
> +
>  MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
>  M:	Felipe Balbi <felipe.balbi@nokia.com>
>  L:	linux-usb@vger.kernel.org

-- 
Dmitry
