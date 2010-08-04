Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab0HDNHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:07:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:49067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628Ab0HDNHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:07:05 -0400
Date: Wed, 4 Aug 2010 15:07:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]hostap:hostap_hw.c Fix typo.
In-Reply-To: <1280782243-14778-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1008041506570.29919@pobox.suse.cz>
References: <1280782243-14778-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, Justin P. Mattock wrote:

> The patch below fixes a typo in a comment.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/net/wireless/hostap/hostap_hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
> index 2f999fc..e9d9d62 100644
> --- a/drivers/net/wireless/hostap/hostap_hw.c
> +++ b/drivers/net/wireless/hostap/hostap_hw.c
> @@ -1896,7 +1896,7 @@ fail:
>  /* Some SMP systems have reported number of odd errors with hostap_pci. fid
>   * register has changed values between consecutive reads for an unknown reason.
>   * This should really not happen, so more debugging is needed. This test
> - * version is a big slower, but it will detect most of such register changes
> + * version is a bit slower, but it will detect most of such register changes
>   * and will try to get the correct fid eventually. */
>  #define EXTRA_FID_READ_TESTS

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
