Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1LGMPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:15:39 -0500
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:59863 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755357Ab1LGMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:15:38 -0500
X-Greylist: delayed 140510 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Dec 2011 07:15:37 EST
Subject: Re: [PATCH] resource cgroups: remove bogus cast
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Pavel Emelianov <xemul@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
In-Reply-To: <1323119621.3244.1.camel@offbook>
References: <1323119621.3244.1.camel@offbook>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 07 Dec 2011 13:15:32 +0100
Message-ID: <1323260132.3318.0.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Mon, 2011-12-05 at 22:13 +0100, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> The memparse() function already accepts const char * as the parsing string.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  kernel/res_counter.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 34683ef..6d269cc 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -159,8 +159,7 @@ int res_counter_memparse_write_strategy(const char *buf,
>  		return 0;
>  	}
>  
> -	/* FIXME - make memparse() take const char* args */
> -	*res = memparse((char *)buf, &end);
> +	*res = memparse(buf, &end);
>  	if (*end != '\0')
>  		return -EINVAL;
>  


