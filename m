Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2EMOAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:00:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61538 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2EMOAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <4FAFB85F.1030604@mvista.com>
References: <CAOf1Mzv=+zSVCDgPcHhVvN6YCbhM8R2w6DDL80EbYTuA0EGpCw@mail.gmail.com>
 <4FAFB85F.1030604@mvista.com>
From: Girish Verma <girish@circuitsutra.com>
Date: Sun, 13 May 2012 19:30:19 +0530
Message-ID: <CAOf1Mzt788H9B7hV3G_t8Atr5S-8m_2_1AOT=kxSVbNvqczg8Q@mail.gmail.com>
Subject: Re: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address
 calculation in inc_enq and inc_deq function
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank for the information, I will resend the patch

On Sun, May 13, 2012 at 7:04 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 13-05-2012 5:06, Girish Verma wrote:
>
>> Hi,
>
>
>   Greeting shouldn't be a part of the changelog.
>
>
>> in xhci-ring.c, function inc_enq and inc_deq calculate the dma address
>> of trb but never used. This calculation may be used for debugging
>> purpose, in that case this code should be part of debug flag.
>
>
>> Signed-off-by: Girish Verma<girish@circuitsutra.com>
>> ---
>>  drivers/usb/host/xhci-ring.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>
>
>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
>> index 3d9422f..dcd67c1 100644
>> --- a/drivers/usb/host/xhci-ring.c
>> +++ b/drivers/usb/host/xhci-ring.c
>
> [...]
>
>> @@ -168,7 +167,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct
>> xhci_ring *ring)
>>                ring->dequeue = ring->deq_seg->trbs;
>>                next = ring->dequeue;
>>        }
>> -       addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg,
>> ring->dequeue);
>
>
>   Your patch is line-wrapped. Maybe the amintainer would be able to fix this
> tho...
>
> WBR, Sergei
