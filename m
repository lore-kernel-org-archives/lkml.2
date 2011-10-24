Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1JXWXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:23:54 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33834 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1JXWXw (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 24 Oct 2011 18:23:52 -0400
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
From: joeyli <jlee@suse.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Joey Lee <jlee@novell.com>
In-Reply-To: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 06:22:47 +0800
Message-ID: <1319494967.17773.156.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2011-10-13 於 14:51 +0800，Ike Panhc 提到：
> BugLink: http://launchpad.net/bugs/836865
> BugLink: http://launchpad.net/bugs/826784
> 
> There are reports say that acer-wmi is loaded on Thinkpad E520 which
> cause wireless connection hard blocked and we can not unblock it. It
> will be better not to load acer-wmi on this machine.
> 
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  drivers/platform/x86/acer-wmi.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index af2bb20..dc9a116 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -325,6 +325,13 @@ static struct dmi_system_id __devinitdata acer_blacklist[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
>  		},
>  	},
> +	{
> +		.ident = "Lenovo Thinkpad Edge E520",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "114320U"),
> +		},
> +	},
>  	{}
>  };
>  

Unfortunately didn't see any useful EC register for unblock wifi rfkill in acer-wmi, let's 
add this device to blacklist.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>


Thank's a lot!
Joey Lee

