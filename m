Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2EMNfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:35:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34159 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab2EMNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:34:52 -0400
Message-ID: <4FAFB85F.1030604@mvista.com>
Date: Sun, 13 May 2012 17:34:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Girish Verma <girish@circuitsutra.com>
CC: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address calculation
 in inc_enq and inc_deq function
References: <CAOf1Mzv=+zSVCDgPcHhVvN6YCbhM8R2w6DDL80EbYTuA0EGpCw@mail.gmail.com>
In-Reply-To: <CAOf1Mzv=+zSVCDgPcHhVvN6YCbhM8R2w6DDL80EbYTuA0EGpCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-05-2012 5:06, Girish Verma wrote:

> Hi,

    Greeting shouldn't be a part of the changelog.

> in xhci-ring.c, function inc_enq and inc_deq calculate the dma address
> of trb but never used. This calculation may be used for debugging
> purpose, in that case this code should be part of debug flag.

> Signed-off-by: Girish Verma<girish@circuitsutra.com>
> ---
>   drivers/usb/host/xhci-ring.c |    4 ----
>   1 files changed, 0 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 3d9422f..dcd67c1 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
[...]
> @@ -168,7 +167,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct
> xhci_ring *ring)
>   		ring->dequeue = ring->deq_seg->trbs;
>   		next = ring->dequeue;
>   	}
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg,
> ring->dequeue);

    Your patch is line-wrapped. Maybe the amintainer would be able to fix this 
tho...

WBR, Sergei
