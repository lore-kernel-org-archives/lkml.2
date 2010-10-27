Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab0J0QDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:03:11 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.106]:44197 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756235Ab0J0QDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:03:10 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Oct 2010 12:03:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=AErQISpoIGgNeKoayE5HBcLF6Z4tix8maDXLeK1gwr8P2AoRtGgnANhkMoDCYTpjo5wwmgm2T1Q+YMviO+RUkyNUG8GLHZ3bgSBkzfo6EY0Y87sdGsUks4lcsYjcDd6X95jqwehmMRiIGzruCjC778QnhNUKbtp1nya0DjDGU7s=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: wvYTmNEVM1nV8.iEXEK6CQQisO78t0Ggcor.UK_MInEkzOp
 8l6gE.u4fTC.G.KH8XpPfuETIPbYvcQPrN0Qyj6fcydy0pxL9Up16PGmCLOf
 7u6i1.LWBvKfaZBM1i205hm5n8Upm8_HJgsikg0H.ngf85._4brNqVQfRGdJ
 J7Misx.YpKgfWO20UWe2tKwajbHVN.v7BZF4zQdP85ZcEIkssNrYqUxU1VmV
 pzzYN1FHLPbjrpNZSvHu_wajguCt60nV5cHATi7QfY71fvB8QCKHobYC7lem
 YGeCtB.Ohx5toEvrHfQVLfFPG1ChPJB.IU_bMrNR8.kPR2dgerGfezoE4dwB
 ukOQ-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] USB: gadget: composite: Typo fix.
From: David Brownell <david-b@pacbell.net>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288167541-12786-1-git-send-email-marek.belisko@gmail.com>
References: <1288167541-12786-1-git-send-email-marek.belisko@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 27 Oct 2010 08:56:27 -0700
Message-ID: <1288194987.2038.8466.camel@helium>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 10:19 +0200, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  drivers/usb/gadget/composite.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 7b5cc16..d3493fe 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1126,7 +1126,7 @@ static int composite_bind(struct usb_gadget *gadget)
>  	cdev->desc = *composite->dev;
>  	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
>  
> -	/* stirng overrides */
> +	/* string overrides */
>  	if (iManufacturer || !cdev->desc.iManufacturer) {
>  		if (!iManufacturer && !composite->iManufacturer &&
>  		    !*composite_manufacturer)



