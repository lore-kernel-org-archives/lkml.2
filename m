Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1JNPty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:49:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47601 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1JNPtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <1318595240.6132.57.camel@x61.thuisdomein>
References: <1318595240.6132.57.camel@x61.thuisdomein>
From: Matt Turner <mattst88@gmail.com>
Date: Fri, 14 Oct 2011 11:49:32 -0400
Message-ID: <CAEdQ38FzXyqoWDO_EykhpAH8msjeEkK9WWrHwGOyeESdAmD10g@mail.gmail.com>
Subject: Re: [PATCH 01/21] alpha: drop unused Kconfig symbol
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 8:27 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/alpha/Kconfig |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index 8bb9362..3d74801 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -445,11 +445,6 @@ config ALPHA_EV67
>          Is this a machine based on the EV67 core?  If in doubt, select N here
>          and the machine will be treated as an EV6.
>
> -config ALPHA_EV7
> -       bool
> -       depends on ALPHA_MARVEL
> -       default y
> -
>  config ALPHA_MCPCIA
>        bool
>        depends on ALPHA_RAWHIDE
> --
> 1.7.4.4

Reviewed-by: Matt Turner <mattst88@gmail.com>

I haven't gotten my kernel.org tree set back up yet, so someone else
might want to take this patch.

Matt
