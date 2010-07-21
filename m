Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0GUPda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:33:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63942 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0GUPd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BAfxWlIi4ueya+JURtTuiug2ltdmNhVgd83UluzJd7d6QW4ymRp9Af5zkgT1tauxfb
         VHmU/8ujfEphkmzwyhVsJ3JiYMUudPgHB5WxyamFfur1JrwVP7xz067k8wQ714Am5FAy
         vuE1tXCBWr/fVulKzchhWtDjq37yjA2pvEykI=
MIME-Version: 1.0
In-Reply-To: <1279321888-27335-1-git-send-email-dbaryshkov@gmail.com>
References: <1279321888-27335-1-git-send-email-dbaryshkov@gmail.com>
Date: Wed, 21 Jul 2010 19:33:26 +0400
Message-ID: <AANLkTimr363aK=DTj7Eb1hJiu9d80Z460feU9K920H-w@mail.gmail.com>
Subject: Re: [PATCH] edac/Kconfig: reenable edac_mpc85xx on MPC85xx
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>,
        bluesmoke-devel@lists.sourceforge.net, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What about this patch. Is it ok?

On Sat, Jul 17, 2010 at 3:11 AM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> Somewhere after 2.6.32 MPC85xx got renamed to FSL_BOOKE (to include
> QorIQ family of chips). However drivers/edac/Kconfig wasn't updated to
> reflect this change. Fix it now.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@kernel.org
> ---
>  drivers/edac/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index aedef79..2328c95 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -209,7 +209,7 @@ config EDAC_I5100
>
>  config EDAC_MPC85XX
>        tristate "Freescale MPC83xx / MPC85xx"
> -       depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
> +       depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || FSL_SOC_BOOKE)
>        help
>          Support for error detection and correction on the Freescale
>          MPC8349, MPC8560, MPC8540, MPC8548
> --
> 1.7.1
>
>



-- 
With best wishes
Dmitry
