Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1FXHe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:34:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45480 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1FXHeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TBxhHEfCZV2QHMWo7Q1MRjTYJvx4Wjyk2X6vRPzyT8tQTNbzoDylFB2qTZFtcWfIdh
         5Ra/HUADSYH7kf9pRlVsnqkaTqKaTA1zZsMunpW1+yzUOKO44LkTLU4EPfhYDdlzUnTs
         puc6+gO6wbXculZf9Ym3snK+OlQajWXztGZKA=
MIME-Version: 1.0
In-Reply-To: <6002eb70809bb1c87c84f32ab4a4f034d2d1ffb5.1308868289.git.joe@perches.com>
References: <6002eb70809bb1c87c84f32ab4a4f034d2d1ffb5.1308868289.git.joe@perches.com>
Date: Fri, 24 Jun 2011 09:34:21 +0200
Message-ID: <BANLkTinrzbuM6TvEJkMmQKkwdf=RTSCxuw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rt2x00: Fix unspeficied typo
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 12:35 AM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index 167d458..5900474 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -54,7 +54,7 @@
>  * @QID_RX: RX queue
>  * @QID_OTHER: None of the above (don't use, only present for completeness)
>  * @QID_BEACON: Beacon queue (value unspecified, don't send it to device)
> - * @QID_ATIM: Atim queue (value unspeficied, don't send it to device)
> + * @QID_ATIM: Atim queue (value unspecified, don't send it to device)
>  */
>  enum data_queue_qid {
>        QID_AC_VO = 0,
> --
> 1.7.6.rc1
>
>
