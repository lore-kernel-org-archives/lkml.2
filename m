Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2JPPdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:33:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab2JPPdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:33:44 -0400
Message-ID: <507D7E54.3050101@ti.com>
Date: Tue, 16 Oct 2012 11:33:40 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-keystone@list.ti.com>
Subject: Re: [RESEND PATCH 2/2] Documentation: of-serial.txt - update for
 clocks phandle for clk
References: <1350401051-8254-1-git-send-email-m-karicheri2@ti.com> <1350401051-8254-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1350401051-8254-2-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:24 AM, Murali Karicheri wrote:
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>
> diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> index 0847fde..423b7ff 100644
> --- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
> @@ -14,7 +14,10 @@ Required properties:
>   	- "serial" if the port type is unknown.
>   - reg : offset and length of the register set for the device.
>   - interrupts : should contain uart interrupt.
> -- clock-frequency : the input clock frequency for the UART.
> +- clock-frequency : the input clock frequency for the UART
> +	 or
> +  clocks phandle to refer to the clk used as per Documentation/devicetree
> +  /bindings/clock/clock-bindings.txt
>   
>   Optional properties:
>   - current-speed : the current active speed of the UART.

