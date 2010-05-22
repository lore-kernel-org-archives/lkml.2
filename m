Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0EVRhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:37:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64884 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0EVRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wm/Cd//KdZk/oUr/4aUyqEPNQjVfG341e96YoC9twK0N71s/alBlwgIBkRSGFMMucu
         qifc9MrF7CBJR38m9T38WCJxDEjYlL8u49PTCh+RRpK/I9OkFIR0A+aKnXKq0S27QDtQ
         zZZHp3thNeG79qw5SO1Hhfo1SG2lSlxcCF8UE=
Date: Sat, 22 May 2010 10:35:12 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: Timofey Trofimov <tumoxep@gmail.com>
Cc: gregkh@suse.de, lieb@canonical.com, more.andres@gmail.com,
       forest@alittletooquiet.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: fix brace coding style issue in
 80211mgr.c This is a patch to the 80211mgr.c file that fixes up a brace
 warning found by the checkpatch.pl tool Signed-off-by: Timofey Trofimov
 <tumoxep@gmail.com>
Message-ID: <20100522173510.GA26310@fujitsu>
References: <1274546574-8338-1-git-send-email-tumoxep@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1274546574-8338-1-git-send-email-tumoxep@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Timofey,

I think the message you send should have the Signed-off-by in the body,
as well as the long description of the patch.

On Sat, May 22, 2010 at 08:42:54PM +0400, Timofey Trofimov wrote:
> ---
>  drivers/staging/vt6656/80211mgr.c |  514 ++++++++++++++++++-------------------
>  1 files changed, 251 insertions(+), 263 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
> index f24dc55..7236019 100644
> --- a/drivers/staging/vt6656/80211mgr.c
> +++ b/drivers/staging/vt6656/80211mgr.c
> @@ -67,8 +67,8 @@
>  
>  /*---------------------  Static Variables  --------------------------*/
>  
> -static int          msglevel                =MSG_LEVEL_INFO;
> -//static int          msglevel                =MSG_LEVEL_DEBUG;
> +static int          msglevel                = MSG_LEVEL_INFO;
> +/*static int          msglevel                =MSG_LEVEL_DEBUG;*/
>  /*---------------------  Static Functions  --------------------------*/

Here, even if the code is commented you could add the extra space, in
case the code is uncommented later.

Charles.
