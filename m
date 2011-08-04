Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1HDNmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:42:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1HDNmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:42:14 -0400
Date: Thu, 4 Aug 2011 15:42:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix kernel-doc comment typo '@id'
In-Reply-To: <1312381119.30457.5.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1108041542080.32288@pobox.suse.cz>
References: <1312381119.30457.5.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with scripts/kernel-doc only.
> 
>  lib/idr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index e15502e..e0abbc1 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -858,7 +858,7 @@ EXPORT_SYMBOL(ida_get_new_above);
>   * and go back to the idr_pre_get() call.  If the idr is full, it will
>   * return %-ENOSPC.
>   *
> - * @id returns a value in the range %0 ... %0x7fffffff.
> + * @p_id returns a value in the range %0 ... %0x7fffffff.
>   */
>  int ida_get_new(struct ida *ida, int *p_id)
>  {

Applied.

-- 
Jiri Kosina
SUSE Labs
