Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1BNXLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:11:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12507 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1BNXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:11:31 -0500
Date: Tue, 15 Feb 2011 00:10:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] fix comment typo initilaization
In-Reply-To: <1297724802.1793.36.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102150009050.4530@swampdragon.chaosbits.net>
References: <1297724802.1793.36.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  fs/fuse/cuse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
> index 3e87cce..7c39b88 100644
> --- a/fs/fuse/cuse.c
> +++ b/fs/fuse/cuse.c
> @@ -458,7 +458,7 @@ static void cuse_fc_release(struct fuse_conn *fc)
>   * @file: file struct being opened
>   *
>   * Userland CUSE server can create a CUSE device by opening /dev/cuse
> - * and replying to the initilaization request kernel sends.  This
> + * and replying to the initialization request kernel sends.  This
>   * function is responsible for handling CUSE device initialization.
>   * Because the fd opened by this function is used during
>   * initialization, this function only creates cuse_conn and sends
> 

Trivial and obviously correct. But since I actually took the time to 
verify the spelling, I'll add my reviewed-by ;-)

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

