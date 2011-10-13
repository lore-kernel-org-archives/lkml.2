Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1JMQgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:36:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34991 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1JMQgj (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 13 Oct 2011 12:36:39 -0400
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
From: joeyli <jlee@suse.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Joey Lee <jlee@novell.com>
In-Reply-To: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 00:35:59 +0800
Message-ID: <1318523759.1913.68.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ike, 

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

Could you please share Thinkpad edge E520's acpidump and dmidecode log
to me? 
Maybe we can capture how does it works with EC register like we support
Ideapad S205 in acer-wmi driver.

Add a machine to blacklist is a last resort, I don't want to accept it
before we try.


Thank's a lot!
Joey Lee


