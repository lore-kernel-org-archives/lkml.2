Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1EYUrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:47:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab1EYUr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:47:29 -0400
Message-ID: <4DDD6B1F.1060303@suse.cz>
Date: Wed, 25 May 2011 22:48:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com
Subject: Re: [PATCH 27/34] gfs2: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-28-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-28-git-send-email-mmarek@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.4.2011 16:59, Michal Marek napsal(a):
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  fs/gfs2/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Hi,

I don't see this patch in today's linux-next. Any objection against me
applying it to the kbuild-2.6.git repository?

Thanks,
Michal


> diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
> index 72c31a3..07d057b 100644
> --- a/fs/gfs2/main.c
> +++ b/fs/gfs2/main.c
> @@ -143,7 +143,7 @@ static int __init init_gfs2_fs(void)
>  
>  	gfs2_register_debugfs();
>  
> -	printk("GFS2 (built %s %s) installed\n", __DATE__, __TIME__);
> +	printk("GFS2 installed\n");
>  
>  	return 0;
>  

