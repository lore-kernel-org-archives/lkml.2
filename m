Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1CPFN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:13:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34218 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1CPFNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gdOy0WuiOCEfBkGnDPcaEXRUbR+Fofq6+H5199YnRpAeUcflCpGPkaXLECnF54bMVb
         iFhfk6vz7qDsC/sb6cHKPAdfmzypIEoks3EsezoKZNeITuAyB0L0V4h1LTmqTl46+VJb
         qKCFJl6zDV+sdBsNwG6A6wpWiBiZcrCQMZeU8=
Date: Wed, 16 Mar 2011 13:13:13 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, dev.rck@gmail.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 3/6] Documentation: update header filename in
 CodingStyle
Message-ID: <20110316051311.GA3984@gmail.com>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	linux-kernel@vger.kernel.org, dev.rck@gmail.com,
	torvalds@linux-foundation.org
References: <20110315134316.465b6e2c.rdunlap@xenotime.net>
 <20110315161152.4bee194f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315161152.4bee194f.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 04:11:52PM -0700, Randy Dunlap wrote:
> From: Roland Kammerer <dev.rck@gmail.com>
> 
> pr_info() and pr_debug() are in linux/printk.h, not linux/kernel.h.
> Last updated is unnecessary, we have git for that.
> 
> Signed-off-by: Roland Kammerer <dev.rck@gmail.com>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  Documentation/CodingStyle |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- lnx-2638-rc8.orig/Documentation/CodingStyle
> +++ lnx-2638-rc8/Documentation/CodingStyle
> @@ -659,7 +659,7 @@ There are a number of driver model diagn
>  which you should use to make sure messages are matched to the right device
>  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
>  dev_info(), and so forth.  For messages that aren't associated with a
> -particular device, <linux/kernel.h> defines pr_debug() and pr_info().
> +particular device, <linux/printk.h> defines pr_debug() and pr_info().
>  
>  Coming up with good debugging messages can be quite a challenge; and once
>  you have them, they can be a huge help for remote troubleshooting.  Such
> @@ -819,6 +819,3 @@ language C, URL: http://www.open-std.org
>  Kernel CodingStyle, by greg@kroah.com at OLS 2002:
>  http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
>  
> ---
> -Last updated on 2007-July-13.
> -
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
