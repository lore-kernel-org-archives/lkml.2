Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab1FVRN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:13:58 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:37627 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754214Ab1FVRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:13:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PPAOSA/S/kI5xutjuX/NkLc9Yddy07w7/U4nWojiLay4tlV63zg4WYNzpWdtGyl+l1jRt7NB8jfQ95TySb7MlUcMhqrUc3W/Lt7WQ3Z2hIHQitQceYkxJXlee2PFmOQI;
Date: Wed, 22 Jun 2011 10:13:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update reference to memory allocators in CodingStyle to
 include vzalloc()
Message-Id: <20110622101351.9a183856.rdunlap@xenotime.net>
In-Reply-To: <alpine.LNX.2.00.1106221345001.11593@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106221345001.11593@swampdragon.chaosbits.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 13:47:16 +0200 (CEST) Jesper Juhl wrote:

> The list of available general purpose memory allocators in
> Documentation/CodingStyle chapter 14 is incomplete. This patch adds
> the missing vzalloc() to the list.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks Jesper.


> ---
>  Documentation/CodingStyle |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 58b0bf9..fa6e25b 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -680,8 +680,8 @@ ones already enabled by DEBUG.
>  		Chapter 14: Allocating memory
>  
>  The kernel provides the following general purpose memory allocators:
> -kmalloc(), kzalloc(), kcalloc(), and vmalloc().  Please refer to the API
> -documentation for further information about them.
> +kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
> +the API documentation for further information about them.
>  
>  The preferred form for passing a size of a struct is the following:
>  
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
