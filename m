Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1HPFpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:45:20 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:64474 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1HPFpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1313454275-5604-6-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
	<1313454275-5604-6-git-send-email-me@akshayjoshi.com>
Date: Tue, 16 Aug 2011 08:45:17 +0300
X-Google-Sender-Auth: Bl0H4y3B_iQrESNG1dqeX-YlKvc
Message-ID: <CAOJsxLFE7osu2Y94OD6YkNrB6jV4UwmM6UCx_djL5OCSCJ2rWg@mail.gmail.com>
Subject: Re: [PATCH 6/9] Staging: Winbond: Remove spacing issues related to pointers.
From: Pekka Enberg <penberg@kernel.org>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 3:24 AM, Akshay Joshi <me@akshayjoshi.com> wrote:
> This patch ensures that spacing around pointers is consistent and
> follows the kernel coding style.
>
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
> ---
>  drivers/staging/winbond/wb35rx_f.h |    4 ++--
>  drivers/staging/winbond/wb35rx_s.h |    4 ++--
>  drivers/staging/winbond/wb35tx_s.h |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
> index 4efc790..8f51136 100644
> --- a/drivers/staging/winbond/wb35rx_f.h
> +++ b/drivers/staging/winbond/wb35rx_f.h
> @@ -8,8 +8,8 @@
>  * Interface function declare
>  */
>  unsigned char          Wb35Rx_initial(struct hw_data *pHwData);
> -void           Wb35Rx_destroy(struct hw_data * pHwData);
> -void           Wb35Rx_stop(struct hw_data * pHwData);
> +void           Wb35Rx_destroy(struct hw_data *pHwData);
> +void           Wb35Rx_stop(struct hw_data *pHwData);
>  void           Wb35Rx_start(struct ieee80211_hw *hw);
>
>  #endif
> diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
> index 949e4f5..e99475db 100644
> --- a/drivers/staging/winbond/wb35rx_s.h
> +++ b/drivers/staging/winbond/wb35rx_s.h
> @@ -35,9 +35,9 @@ struct wb35_rx {
>        u32     Rx3UrbCancel;
>
>        u32     LastR1; /* For RSSI reporting */
> -       struct urb *                            RxUrb;
> +       struct urb *RxUrb;
>        u32             Ep3ErrorCount2; /* 20060625.1 Usbd for Rx DMA error count */
>
>        int             EP3VM_status;
> -       u8 *    pDRx;
> +       u8 *pDRx;
>  };
> diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
> index 83b4b0f..fda18d6 100644
> --- a/drivers/staging/winbond/wb35tx_s.h
> +++ b/drivers/staging/winbond/wb35tx_s.h
> @@ -31,8 +31,8 @@ struct wb35_tx {
>        u32         EP4vm_state; /* for EP4vm state */
>        u32         tx_halt; /* Stopping VM */
>
> -       struct urb *                            Tx4Urb;
> -       struct urb *                            Tx2Urb;
> +       struct urb *Tx4Urb;
> +       struct urb *Tx2Urb;
>
>        int             EP2VM_status;
>        int             EP4VM_status;

If you're doing this, can you please then fix up all the struct
members to be consistent? I personally prefer the perf and x86 style
where you align members like this (with tabs):

        u32                               EP4vm_state;
        u32                               tx_halt;
        struct urb                      *Tx4Urb;

etc...

                       Pekka
