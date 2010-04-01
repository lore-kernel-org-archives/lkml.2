Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0DAJUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:20:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0DAJUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:20:07 -0400
Date: Thu, 1 Apr 2010 11:20:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove empty comment.
In-Reply-To: <1270077774-4399-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1004011119520.8345@pobox.suse.cz>
References: <1270077774-4399-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Justin P. Mattock wrote:

> Remove an empty comment.
> 
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  drivers/acpi/power.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 0f30c3c..8ed24c2 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -171,7 +171,6 @@ static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
>  		return -EINVAL;
>  
>  	/* The state of the list is 'on' IFF all resources are 'on'. */
> -	/* */
>  
>  	for (i = 0; i < list->count; i++) {
>  		/*

Applied, thanks Justin.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
