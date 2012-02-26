Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab2BZXxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:53:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43065 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568Ab2BZXxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:53:02 -0500
X-Sasl-enc: K+QA8QF8TmDAcWfzg0Zi674+tZpTZjtWMQ39wnK45m+AA00ZpjDRg2eNgA 1330300381
Message-ID: <1330300377.2490.0.camel@perseus.themaw.net>
Subject: Re: [PATCH] autofs: MAINTAINERS: change mailing list
From: Ian Kent <raven@themaw.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 07:52:57 +0800
In-Reply-To: <20120226152938.GB14324@redhat.com>
References: <20120226152938.GB14324@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-26 at 16:29 +0100, Stanislaw Gruszka wrote:
> From 716305073524cb03760d83374661d9d1f1a20c30 Mon Sep 17 00:00:00 2001
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Sun, 26 Feb 2012 16:25:29 +0100
> Subject: [PATCH] autofs: MAINTAINERS: change mailing list
> 
> autofs@linux.kernel.org does not work, replace it by linux-fsdevel
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 75a9a5f..0d6159e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3780,7 +3780,7 @@ F:	Documentation/kdump/
>  
>  KERNEL AUTOMOUNTER v4 (AUTOFS4)
>  M:	Ian Kent <raven@themaw.net>
> -L:	autofs@linux.kernel.org
> +L:	linux-fsdevel@vger.kernel.org
>  S:	Maintained
>  F:	fs/autofs4/
>  

NAK, that's not the correct list.

But thanks for reminding me this needs to be updated.
Ian


