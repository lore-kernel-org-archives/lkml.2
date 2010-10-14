Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab0JNWU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:20:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932302Ab0JNWUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:20:54 -0400
Date: Thu, 14 Oct 2010 15:20:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <michael.hennerich@analog.com>
Cc: linux-kernel@vger.kernel.org, ddbua@analog.com, drivers@analog.com,
        mike.frysinger@analog.com, chrisv@cyberswitching.com
Subject: Re: [PATCH 1/3] drivers: misc: ad525x_dpot: Fix typo in spi write16
 and write24 transfer counts
Message-Id: <20101014152049.9471e1e6.akpm@linux-foundation.org>
In-Reply-To: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
References: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 10:59:46 +0200
<michael.hennerich@analog.com> wrote:

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>  drivers/misc/ad525x_dpot-spi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
> index b8c6df9..6cfcb63 100644
> --- a/drivers/misc/ad525x_dpot-spi.c
> +++ b/drivers/misc/ad525x_dpot-spi.c
> @@ -53,13 +53,13 @@ static int write8(void *client, u8 val)
>  static int write16(void *client, u8 reg, u8 val)
>  {
>  	u8 data[2] = {reg, val};
> -	return spi_write(client, data, 1);
> +	return spi_write(client, data, 2);
>  }
>  
>  static int write24(void *client, u8 reg, u16 val)
>  {
>  	u8 data[3] = {reg, val >> 8, val};
> -	return spi_write(client, data, 1);
> +	return spi_write(client, data, 3);
>  }
>  
>  static int read8(void *client)

What are the runtime effects of this change?
