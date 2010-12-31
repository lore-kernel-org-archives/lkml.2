Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0LaK1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:27:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49159 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0LaK1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=modBgf/4dg+GqKenDH1fmoUCjCZwbXnW3Q20hppWC2P94qQ7VKxJvjxMtP7bKVFQZg
         V+0IvS8uNPU/bV5DUj3EKIW2fE8yuAEc2XJRSzgPpCCQD7tS218hXqhIR/cXsRluwcap
         m3a2jv6V+foEWSQOg3oudtBatQEQNgVJpaauo=
Message-ID: <4D1DAFF5.3090108@gmail.com>
Date: Fri, 31 Dec 2010 08:27:01 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 14/15]include:media:davinci:vpss.h Typo change diable
 to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <1293750484-1161-4-git-send-email-justinmattock@gmail.com> <1293750484-1161-5-git-send-email-justinmattock@gmail.com> <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com> <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293750484-1161-12-git-send-email-justinmattock@gmail.com> <1293750484-1161-13-git-send-email-justinmattock@gmail.com> <1293750484-1161-14-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-14-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-12-2010 21:08, Justin P. Mattock escreveu:
> The below patch fixes a typo "diable" to "disable". Please let me know if this 
> is correct or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

PS.: Next time, please c/c linux-media ONLY on patches related to media
drivers (/drivers/video and the corresponding include files). Having to
dig into a series of 15 patches to just actually look on 3 patches 
is not nice.

> 
> ---
>  include/media/davinci/vpss.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/media/davinci/vpss.h b/include/media/davinci/vpss.h
> index c59cc02..b586495 100644
> --- a/include/media/davinci/vpss.h
> +++ b/include/media/davinci/vpss.h
> @@ -44,7 +44,7 @@ struct vpss_pg_frame_size {
>  	short pplen;
>  };
>  
> -/* Used for enable/diable VPSS Clock */
> +/* Used for enable/disable VPSS Clock */
>  enum vpss_clock_sel {
>  	/* DM355/DM365 */
>  	VPSS_CCDC_CLOCK,

