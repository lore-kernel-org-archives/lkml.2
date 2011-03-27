Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1C0J6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 05:58:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57764 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1C0J6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 05:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ii3hX0deQTsm4xUaKeBNT35bB+W11AITpUDCCkvxHeF4FEgT0NsGfs5yfHJMHq2lUl
         6MjngLQ4xQcPinkCCiN1YsKdZPBdzkW8piQtEJBMu55PPI33irUPrLHOJG1RtHhVd6HL
         UflDaJR8vFvk8oVYTrdGADVWmQDaiUGDnkj3M=
Date: Sun, 27 Mar 2011 17:58:13 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 1/2] Fixed the format of column longer than 80 .
Message-ID: <20110327095810.GA3815@gmail.com>
Mail-Followup-To: Wanlong Gao <wanlong.gao@gmail.com>,
	linux-kernel@vger.kernel.org, greg@kroah.com
References: <1301156726-23610-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301156726-23610-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 12:25:25AM +0800, Wanlong Gao wrote:
Signed-off-by: Gao Wanlong<wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  drivers/base/memory.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>  mode change 100644 => 100755 drivers/base/memory.c
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> old mode 100644
> new mode 100755
> index 3da6a43..3e9aa3d
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -48,7 +48,8 @@ static const char *memory_uevent_name(struct kset *kset, struct kobject *kobj)
>  	return MEMORY_CLASS_NAME;
>  }
>  
> -static int memory_uevent(struct kset *kset, struct kobject *obj, struct kobj_uevent_env *env)
> +static int memory_uevent(struct kset *kset, struct kobject *obj,
> +			struct kobj_uevent_env *env)
>  {
>  	int retval = 0;
>  
> -- 
> 1.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
