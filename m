Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1IHWyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 18:54:11 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:35134 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750902Ab1IHWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 18:54:05 -0400
Message-ID: <4E68FAD5.9060608@xenotime.net>
Date: Thu, 08 Sep 2011 10:26:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] switching-sched.txt: remove 'as' for as is no longer
 supported
References: <4E64E172.7000506@gmail.com>
In-Reply-To: <4E64E172.7000506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/11 07:49, Wang Sheng-Hui wrote:
> The patch is against 3.1-rc3.
> 
> as is no longer supported and we can not use 'elevator=as' any
> more.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Applied, thanks.

> ---
>  Documentation/block/switching-sched.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/block/switching-sched.txt b/Documentation/block/switching-sched.txt
> index 71cfbdc..3b2612e 100644
> --- a/Documentation/block/switching-sched.txt
> +++ b/Documentation/block/switching-sched.txt
> @@ -1,6 +1,6 @@
>  To choose IO schedulers at boot time, use the argument 'elevator=deadline'.
> -'noop', 'as' and 'cfq' (the default) are also available. IO schedulers are
> -assigned globally at boot time only presently.
> +'noop' and 'cfq' (the default) are also available. IO schedulers are assigned
> +globally at boot time only presently.
>  
>  Each io queue has a set of io scheduler tunables associated with it. These
>  tunables control how the io scheduler works. You can find these entries


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
