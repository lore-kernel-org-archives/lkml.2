Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1FMJcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:32:13 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61426 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1FMJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LowhQf8rTeAxy3L9hC4L2Iv2wWM536yt14flowP6yUsJBkJWSIE9sf8qMnhTLaXJ7W
         JlGswjaU+oLwP6UkEDXiDXCJWfDF+G0EPX/n2Vr5y0lQtPbi+tTyZmuMdPgwxzoiYjQf
         /JFp98g6R+rG5mVbR2UVB7djvgQ5aNKu+3dMk=
Date: Mon, 13 Jun 2011 17:31:45 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        xiyoulinuxkernelgroup@googlegroups.com, linux-kernel@zh-kernel.org,
        rdunlap@xenotime.net
Subject: Re: [PATCH] Documentation:change all arch/i386 to arch/x86 in
 Documentation
Message-ID: <20110613093138.GA4990@gmail.com>
Mail-Followup-To: Wanlong Gao <wanlong.gao@gmail.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	xiyoulinuxkernelgroup@googlegroups.com, linux-kernel@zh-kernel.org,
	rdunlap@xenotime.net
References: <1307942898-3728-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1307942898-3728-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 01:28:18PM +0800, Wanlong Gao wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Change all "arch/i386" to "arch/x86" in Documentaion/,
> since the directory has changed.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
Hi Wanlong,
	Thanks for your great work. But you have done many
obsolete jobs. See following.
>  4. Options
>  ~~~~~~~~~~
> -   Some options can be set in the source text (in arch/i386/boot/video.S).
> +   Some options can be set in the source text (in arch/x86/boot/video.S).
>  All of them are simple #define's -- change them to #undef's when you want to
There is no arch/x86/boot/video.S file now. So your change has no 
meaning. You should fix your patch again so that it is well for us.

NOTE: i just put an example file arch/x86/boot/video.S. Maybe there are
still other obsolete files.

Thanks
Harry Wei
