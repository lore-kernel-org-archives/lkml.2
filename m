Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1BNXPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:15:35 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12689 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1BNXPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:15:32 -0500
Date: Tue, 15 Feb 2011 00:14:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] fix comment typo uninitized
In-Reply-To: <1297724835.1793.37.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102150014140.4530@swampdragon.chaosbits.net>
References: <1297724835.1793.37.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  fs/ext4/extents.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6b90b68..1b3d188 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2844,7 +2844,7 @@ fix_extent_len:
>   * ext4_get_blocks_dio_write() when DIO to write
>   * to an uninitialized extent.
>   *
> - * Writing to an uninitized extent may result in splitting the uninitialized
> + * Writing to an uninitialized extent may result in splitting the uninitialized
>   * extent into multiple /initialized uninitialized extents (up to three)
>   * There are three possibilities:
>   *   a> There is no split required: Entire extent should be uninitialized
> 

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

