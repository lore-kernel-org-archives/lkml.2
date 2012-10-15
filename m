Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab2JOO1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:27:07 -0400
Received: from antcom.de ([188.40.178.216]:45053 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab2JOO1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:27:05 -0400
Message-ID: <507C1D37.7060006@antcom.de>
Date: Mon, 15 Oct 2012 16:27:03 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Bakki <srinivas.bakki@nxp.com>,
        Kevin Wells <kevin.wells@nxp.com>
Subject: Re: [PATCH RESEND] usb: gadget: lpc32xx_udc: Disable setup request
 error
References: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com> <1350305256-27295-2-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1350305256-27295-2-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 02:47 PM, Alexandre Pereira da Silva wrote:
> This message is an debugging message. It's useful for finding protocol
> details but it's not necessarily an error.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Roland Stigge <stigge@antcom.de>

Was also confirmed by the NXP developers a while ago, I think.

> ---
> ---
>  drivers/usb/gadget/lpc32xx_udc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
> index 21a9861..d1cf1f4 100644
> --- a/drivers/usb/gadget/lpc32xx_udc.c
> +++ b/drivers/usb/gadget/lpc32xx_udc.c
> @@ -2399,7 +2399,7 @@ static void udc_handle_ep0_setup(struct lpc32xx_udc *udc)
>  
>  		if (i < 0) {
>  			/* setup processing failed, force stall */
> -			dev_err(udc->dev,
> +			dev_dbg(udc->dev,
>  				"req %02x.%02x protocol STALL; stat %d\n",
>  				reqtype, req, i);
>  			udc->ep0state = WAIT_FOR_SETUP;

