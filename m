Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2ADW1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:27:10 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46184 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757099Ab2ADW1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:27:05 -0500
Message-ID: <4F04DFF0.8000006@xenotime.net>
Date: Wed, 04 Jan 2012 15:25:36 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Harry Wei <harryxiyou@gmail.com>,
        xiyoulinuxkernelgroup@googlegroups.com,
        Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Update stable address
References: <1323468720.27746.42.camel@joe2Laptop>
In-Reply-To: <1323468720.27746.42.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 02:12 PM, Joe Perches wrote:
> The Japanese/Korean/Chinese versions still need updating.
> 
> Also, the stable kernel 2.6.x.y descriptions are out of date
> and should be updated as well.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

> ---
>  Documentation/HOWTO                         |    4 ++--
>  Documentation/development-process/5.Posting |    8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 81bc1a9..f7ade3b 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -275,8 +275,8 @@ versions.
>  If no 2.6.x.y kernel is available, then the highest numbered 2.6.x
>  kernel is the current stable kernel.
>  
> -2.6.x.y are maintained by the "stable" team <stable@kernel.org>, and are
> -released as needs dictate.  The normal release period is approximately 
> +2.6.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
> +are released as needs dictate.  The normal release period is approximately
>  two weeks, but it can be longer if there are no pressing problems.  A
>  security-related problem, instead, can cause a release to happen almost
>  instantly.
> diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
> index 903a254..8a48c9b 100644
> --- a/Documentation/development-process/5.Posting
> +++ b/Documentation/development-process/5.Posting
> @@ -271,10 +271,10 @@ copies should go to:
>     the linux-kernel list.
>  
>   - If you are fixing a bug, think about whether the fix should go into the
> -   next stable update.  If so, stable@kernel.org should get a copy of the
> -   patch.  Also add a "Cc: stable@kernel.org" to the tags within the patch
> -   itself; that will cause the stable team to get a notification when your
> -   fix goes into the mainline.
> +   next stable update.  If so, stable@vger.kernel.org should get a copy of
> +   the patch.  Also add a "Cc: stable@vger.kernel.org" to the tags within
> +   the patch itself; that will cause the stable team to get a notification
> +   when your fix goes into the mainline.
>  
>  When selecting recipients for a patch, it is good to have an idea of who
>  you think will eventually accept the patch and get it merged.  While it
> 
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
