Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0KIX4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:56:44 -0500
Received: from kroah.org ([198.145.64.141]:46012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0KIX4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:56:41 -0500
Date: Tue, 9 Nov 2010 15:50:37 -0800
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/39] drivers/staging: Update WARN uses
Message-ID: <20101109235037.GB9001@kroah.com>
References: <cover.1288471897.git.joe@perches.com>
 <8312f0d8caf92953b08390be149a9c0ac49ad516.1288471898.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8312f0d8caf92953b08390be149a9c0ac49ad516.1288471898.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 02:08:38PM -0700, Joe Perches wrote:
> Add missing newlines.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/memrar/memrar_allocator.c    |    2 +-
>  drivers/staging/solo6x10/solo6010-v4l2-enc.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
> index a4f8c58..705bde8 100644
> --- a/drivers/staging/memrar/memrar_allocator.c
> +++ b/drivers/staging/memrar/memrar_allocator.c
> @@ -74,7 +74,7 @@ struct memrar_allocator *memrar_create_allocator(unsigned long base,
>  	 * and issue a diagnostic.
>  	 */
>  	WARN(capacity < block_size * 2,
> -	     "memrar: Only one block available to allocator.\n");
> +	     "memrar: Only one block available to allocator\n");

There already is a new line here.  So I'll remove this part of the
patch.

thanks,

greg k-h
