Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1FFU6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:58:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54538 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1FFU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EJz+O5+DShVLovSzJFi1nbCLrMejr2GISI4zcvb8hJhhIqk6Z61A4J1HJ0ae8q3xcJ
         Hm8Ih6bCsUVWJp6qTw84gGh8Qqez5CJ29A2rTXVSvnUOkotOmOlQe82fO9zWb3OZ19iW
         m0ckF7/yLY1+2LG11O6kM7Za8WXZR5gVi7gPo=
Subject: Re: [PATCH 3/3] atomic: generalize atomic_add_unless_return
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <1307381251-15729-3-git-send-email-asharma@fb.com>
References: <1307381251-15729-1-git-send-email-asharma@fb.com>
	 <1307381251-15729-3-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 22:58:13 +0200
Message-ID: <1307393893.2642.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 10:27 -0700, Arun Sharma a écrit :
> commit 686a7e3 added atomic_add_unless_return() to get something going
> for the stable branch.
> 
> Move the primitive to <linux/atomic.h>
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: David Miller <davem@davemloft.net>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> LKML-Reference: <20110531105019.GF24172@elte.hu>
> ---
>  include/linux/atomic.h |   15 +++++++++++++++
>  net/ipv4/inetpeer.c    |   17 ++---------------
>  2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> index fc31190..3489d9c 100644
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -17,6 +17,21 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
>  }

Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>


