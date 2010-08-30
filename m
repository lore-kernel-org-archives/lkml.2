Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0H3P4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:56:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab0H3P4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:56:23 -0400
Message-ID: <4C7BD45B.3050300@kernel.org>
Date: Mon, 30 Aug 2010 17:55:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Naohiro Aota <naota@elisp.net>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
References: <m27hj8cdsw.fsf@elisp.net> <m2pqx0az4h.fsf@elisp.net>
In-Reply-To: <m2pqx0az4h.fsf@elisp.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 15:55:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 05:39 PM, Naohiro Aota wrote:
> It was unclear in original kernel-doc how nextidp worked in
> idr_get_next(). Let's describe it.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>
> ---
>  lib/idr.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index fb86a67..cf8c46b 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -589,7 +589,8 @@ EXPORT_SYMBOL(idr_for_each);
>   * @nextidp:  pointer to lookup key
>   *
>   * Returns pointer to registered object with id, which is next number to
> - * given id.
> + * given id. The id pointed by nextidp will be updated
> + * appropriately for next iteration.
>   */

Maybe "After being looked up, *@nextidp will be updated for the next
iteration" would be clearer?

Thanks.

-- 
tejun
