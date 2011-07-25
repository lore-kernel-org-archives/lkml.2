Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1GYV33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:29:29 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:50134 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751772Ab1GYV31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:29:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=diMyPsL9KlziZYFdEJQ10/NCKtFo2knIFXo/AsM+oQGnLIQsVXRIQ9+03MusnWDwJKipz2wUBGxvclEvXfC4VRyE4Ys6EDpw2Re1Znek/WEwoKFVLZh2a/SdD6nAQ86G;
Date: Mon, 25 Jul 2011 14:29:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Documentation: Document ARM's user_debug parameter
Message-Id: <20110725142924.85de25dd.rdunlap@xenotime.net>
In-Reply-To: <1311556514-24728-1-git-send-email-sboyd@codeaurora.org>
References: <1311556514-24728-1-git-send-email-sboyd@codeaurora.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 18:15:14 -0700 Stephen Boyd wrote:

> Usually kernel parameters are documented in kernel-parameters.txt
> but user_debug is only documented in the Kconfig. Document the
> option and point to the Kconfig help text for more info.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>

Is this a superset of 'print_fatal_signals'?

Applied, thanks.

> ---
>  Documentation/kernel-parameters.txt |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index aa47be7..8186adc 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2612,6 +2612,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  					medium is write-protected).
>  			Example: quirks=0419:aaf5:rl,0421:0433:rc
>  
> +	user_debug=	[KNL,ARM]
> +			Format: <int>
> +			See arch/arm/Kconfig.debug help text.
> +				 1 - undefined instruction events
> +				 2 - system calls
> +				 4 - invalid data aborts
> +				 8 - SIGSEGV faults
> +				16 - SIGBUS faults
> +			Example: user_debug=31
> +
>  	userpte=
>  			[X86] Flags controlling user PTE allocations.
>  
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
