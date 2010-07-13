Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0GMNFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 09:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0GMNFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 09:05:49 -0400
Message-ID: <4C3C648F.5010200@gmail.com>
Date: Tue, 13 Jul 2010 15:05:19 +0200
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: dave.bueso@gmail.com
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        trivial@vger.kernel.org
Subject: Re: [PATCH RESEND reiserfs] trivial typo fix
References: <1279014612.18280.1.camel@cowboy>
In-Reply-To: <1279014612.18280.1.camel@cowboy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso wrote:
> Fix trivial typo in code comment (change adn for and), also change comment style for proper coding style.
>
> Thanks,
> Davidlohr
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
>   

Acked-by: Edward Shishkin <edward.shishkin@gmail.com>

> ---
>  include/linux/reiserfs_fs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
> index 3b603f4..ba39416 100644
> --- a/include/linux/reiserfs_fs.h
> +++ b/include/linux/reiserfs_fs.h
> @@ -360,7 +360,7 @@ int is_reiserfs_jr(struct reiserfs_super_block *rs);
>  /* the spot for the super in versions 3.5 - 3.5.10 (inclusive) */
>  #define REISERFS_OLD_DISK_OFFSET_IN_BYTES (8 * 1024)
>  
> -// reiserfs internal error code (used by search_by_key adn fix_nodes))
> +/* reiserfs internal error code (used by search_by_key and fix_nodes)) */
>  #define CARRY_ON      0
>  #define REPEAT_SEARCH -1
>  #define IO_ERROR      -2
>   

