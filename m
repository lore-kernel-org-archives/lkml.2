Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab2IEQQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:16:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41528 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2IEQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:16:41 -0400
Date: Wed, 5 Sep 2012 12:05:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Marcus Karlsson <mk@acc.umu.se>
Cc: gregkh@linuxfoundation.org, xiaoguangrong@linux.vnet.ibm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix spelling of comment
Message-ID: <20120905160555.GA12339@phenom.dumpdata.com>
References: <1346531386-9524-1-git-send-email-mk@acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346531386-9524-1-git-send-email-mk@acc.umu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 10:29:46PM +0200, Marcus Karlsson wrote:
> Fix spelling in tmem.c:
> Transcedent -> Transcendent
> 
> Signed-off-by: Marcus Karlsson <mk@acc.umu.se>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/staging/zcache/tmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
> index eaa9021..56c8e60 100644
> --- a/drivers/staging/zcache/tmem.c
> +++ b/drivers/staging/zcache/tmem.c
> @@ -3,7 +3,7 @@
>   *
>   * Copyright (c) 2009-2011, Dan Magenheimer, Oracle Corp.
>   *
> - * The primary purpose of Transcedent Memory ("tmem") is to map object-oriented
> + * The primary purpose of Transcendent Memory ("tmem") is to map object-oriented
>   * "handles" (triples containing a pool id, and object id, and an index), to
>   * pages in a page-accessible memory (PAM).  Tmem references the PAM pages via
>   * an abstract "pampd" (PAM page-descriptor), which can be operated on by a
> -- 
> 1.7.12
