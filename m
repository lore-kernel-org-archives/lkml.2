Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1BOJ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:26:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab1BOJ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:26:57 -0500
Date: Tue, 15 Feb 2011 10:26:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] fix comment typo initilaization
In-Reply-To: <1297724802.1793.36.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102151026510.2160@pobox.suse.cz>
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

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
