Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1GUMEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:04:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab1GUMD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:03:58 -0400
Date: Thu, 21 Jul 2011 14:03:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: Re: [PATCH][TRIVIAL] uwb: Fix misspelling of neighbourhood in
 comment
In-Reply-To: <alpine.LNX.2.00.1107172113410.32359@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107211403490.7300@pobox.suse.cz>
References: <alpine.LNX.2.00.1107172113410.32359@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011, Jesper Juhl wrote:

> In drivers/uwb/uwbd.c, the word 'neighbourhood' is misspelled as
> 'neighboorhood' in a comment. Fix that.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/uwb/uwbd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/uwb/uwbd.c b/drivers/uwb/uwbd.c
> index 001c8b4..bdcb13c 100644
> --- a/drivers/uwb/uwbd.c
> +++ b/drivers/uwb/uwbd.c
> @@ -256,7 +256,7 @@ static void uwbd_event_handle(struct uwb_event *evt)
>   * UWB Daemon
>   *
>   * Listens to all UWB notifications and takes care to track the state
> - * of the UWB neighboorhood for the kernel. When we do a run, we
> + * of the UWB neighbourhood for the kernel. When we do a run, we
>   * spinlock, move the list to a private copy and release the
>   * lock. Hold it as little as possible. Not a conflict: it is
>   * guaranteed we own the events in the private list.

Applied.

-- 
Jiri Kosina
SUSE Labs
