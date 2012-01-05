Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2AEWFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:05:35 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:60093 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2AEWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:05:34 -0500
Message-ID: <1325801115.1807.13.camel@x61.thuisdomein>
Subject: Re: [PATCH 1/2] time: remove the orphan option
 GENERIC_CLOCKEVENTS_MIGR
From: Paul Bolle <pebolle@tiscali.nl>
To: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Date: Thu, 05 Jan 2012 23:05:15 +0100
In-Reply-To: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
References: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 21:28 +0800, Feng Tang wrote:
> Running grep only see it exit in the kernel/time/Kconfig, so remove it.
> 
> xxx@bee:~/ws2/projects/linux-2.6$ grep GENERIC_CLOCKEVENTS_MIGR ./* -r
> ./kernel/time/Kconfig:  depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>

An identical patch is currently included in the trivial tree. Jiri
Kosina just sent a pull request that (if honored) would include it in
the mainline tree.


Paul Bolle

> ---
>  kernel/time/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index b26c222..2cf9cc7 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -25,7 +25,7 @@ config HIGH_RES_TIMERS
>  config GENERIC_CLOCKEVENTS_BUILD
>  	bool
>  	default y
> -	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
> +	depends on GENERIC_CLOCKEVENTS
>  
>  config GENERIC_CLOCKEVENTS_MIN_ADJUST
>  	bool

