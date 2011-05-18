Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1ERGqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:46:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46653 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1ERGp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GVHaH3mErXGJiEeRmgaJUK2FOaTIecEQOwi/4PBseJtro6eHOM40Q0dl0/Bj82Manq
         LRyH4Vb73zowMvJCW0Kwo8KVdlILG6YlvdSXv+SoDih+1QSPRsfexlQsMrGpih7kL0Mp
         Yc7A0rGvuXYiY2odutKjWnLNAWOt6VT7S/hcE=
Date: Tue, 17 May 2011 23:45:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mohan Pallaka <mpallaka@codeaurora.org>
Cc: linux@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, rmk@dyn-67.arm.linux.org.uk
Subject: Re: [PATCH 1/2] pwm: Add stubs for pwm operations
Message-ID: <20110518064552.GA31801@core.coreip.homeip.net>
References: <1305695926-25855-1-git-send-email-mpallaka@codeaurora.org>
 <1305695926-25855-2-git-send-email-mpallaka@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305695926-25855-2-git-send-email-mpallaka@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:48:45AM +0530, Mohan Pallaka wrote:
> Chip drivers that support both pwm and non-pwm modes
> would encounter compilation errors if the platform doesn't
> have support for pwm, even though the chip is programmed
> to work in non-pwm mode. Add stubs for pwm functions to
> avoid compilation errors in these scenarios.
> 
> Signed-off-by: Mohan Pallaka <mpallaka@codeaurora.org>
> ---
>  include/linux/pwm.h |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 7c77575..f0bc51f 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -3,6 +3,7 @@
>  
>  struct pwm_device;
>  
> +#if defined(CONFIG_PWM)

Shouldn't it be CONFIG_HAVE_PWM?

Thanks.

-- 
Dmitry
