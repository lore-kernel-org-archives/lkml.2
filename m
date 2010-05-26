Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0EZRF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:05:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34827 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0EZRFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wplX8YCVmU/5i3nP4ddQ/R7+iqSbqXWUM1LXWpIIEbRJwpqAgOpaPTcleRWb87WdGw
         rLrXRlP+xwQY7rVKC4ncd9sqHPbUWw8G32woM34woatox+nNbVARFTACVG47ckbsoTgj
         NXOKRdfoWepHD2Mli8XgGXbfeT1YvNO8utego=
MIME-Version: 1.0
In-Reply-To: <1274892555-10422-1-git-send-email-justinmattock@gmail.com>
References: <1274892555-10422-1-git-send-email-justinmattock@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:05:35 -0700
Message-ID: <AANLkTim1qNEXJB38p_MEQxfjhWRe1-kPfNFq3JL11qgl@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH]wireless:ath9k Fix ath_print in xmit.c
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       mcgrog@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 9:49 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> ath_print in xmit.c should say "Reseting hardware"
> instead of Reaseting HAL!(since HAL is being fazed out).
> dmesg shows:
> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3db1917..2a0558e 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>                int r;
>
>                ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to stop TxDMA. Reset HAL!\n");
> +                         "Unable to stop TxDMA. Reseting hardware!\n");

Thanks for the patch but you need to send this to John, cc linux-wireless.

  Luis
