Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1IZQ66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:58:58 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58808 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750851Ab1IZQ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:58:57 -0400
Message-ID: <4E80AF4F.1030706@xenotime.net>
Date: Mon, 26 Sep 2011 09:58:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Wizard <wizarddewhite@gmail.com>
CC: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org
Subject: Re: [PATCH]   fix find_next_system_ram comments
References: <1317045482-3355-1-git-send-email-wizarddewhite@gmail.com>
In-Reply-To: <1317045482-3355-1-git-send-email-wizarddewhite@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 06:58 AM, Wizard wrote:
> The purpose of find_next_system_ram() is to find a the lowest
> memory resource which contain or overlap the [res->start, res->end),
> not just contain.
> 
> In this patch, I make this comment more exact and fix one typo.
> 
> Signed-off-by: Wizard <wizarddewhite@gmail.com>

For Signed-off-by: Documentation/SubmittingPatches says:

using your real name (sorry, no pseudonyms or anonymous contributions.)

> ---
>  kernel/resource.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 3b3cedc..2751a8c 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -279,7 +279,8 @@ EXPORT_SYMBOL(release_resource);
>  
>  #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>  /*
> - * Finds the lowest memory reosurce exists within [res->start.res->end)
> + * Finds the lowest memory resource which contains or overlaps
> + * [res->start.res->end)

Your patch description uses ", " (comma) here.  I think that's better than
keeping the ".".

>   * the caller must specify res->start, res->end, res->flags and "name".
>   * If found, returns 0, res is overwritten, if not found, returns -1.
>   */


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
