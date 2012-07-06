Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2GFAAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:00:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38781 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab2GFAAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:00:16 -0400
MIME-Version: 1.0
In-Reply-To: <f8b1a055-eb85-41c1-b08d-05ee0611b2b7@AM1EHSMHS020.ehs.local>
References: <f8b1a055-eb85-41c1-b08d-05ee0611b2b7@AM1EHSMHS020.ehs.local>
Date: Thu, 5 Jul 2012 17:00:14 -0700
Message-ID: <CAB9O=CNiA+ypPYAGFKoxpW7BBL0Tg5Je+NF-+KOkqkrX2FTZuw@mail.gmail.com>
Subject: Re: FW: [PATCH 2/3] ARM: zynq: Add compatible entry for the ZC702 board.
From: John Linn <johnhlinn@gmail.com>
To: nbowler@elliptictech.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:32 PM, John Linn <John.Linn@xilinx.com> wrote:
>
>
> -----Original Message-----
> From: Nick Bowler [mailto:nbowler@elliptictech.com]
> Sent: Wednesday, July 04, 2012 7:14 AM
> To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Cc: Russell King; John Linn
> Subject: [PATCH 2/3] ARM: zynq: Add compatible entry for the ZC702
> board.
>
> This allows the kernel to start on this platform with the
> vendor-provided device tree blob.
>
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> Cc: John Linn <john.linn@xilinx.com>

Signed-off-by: John Linn <johnhlinn@gmail.com>

>
> ---
>  arch/arm/mach-zynq/common.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 12a2984..a58c83b 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -106,6 +106,7 @@ static void __init xilinx_map_io(void)
>
>  static const char *xilinx_dt_match[] = {
>         "xlnx,zynq-ep107",
> +       "xlnx,zynq-zc702",
>         NULL
>  };
>
> --
> 1.7.8.6
>
>
>
>
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
>
>
