Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2J2JEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:04:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:40082 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150Ab2J2JEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:04:21 -0400
Message-ID: <508E54AA.1040002@atmel.com>
Date: Mon, 29 Oct 2012 11:04:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: add pinctrl atmel at91 entry
References: <1351360392-8669-1-git-send-email-plagnioj@jcrosoft.com> <1351360392-8669-2-git-send-email-plagnioj@jcrosoft.com>
In-Reply-To: <1351360392-8669-2-git-send-email-plagnioj@jcrosoft.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 07:53 PM, Jean-Christophe PLAGNIOL-VILLARD :
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  MAINTAINERS |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 027ec2b..cb97031 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5624,6 +5624,12 @@ S:	Maintained
>  F:	drivers/pinctrl/
>  F:	include/linux/pinctrl/
>  
> +PIN CONTROLLER - ATMEL AT91
> +M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pinctrl/pinctrl-at91.c
> +
>  PIN CONTROLLER - ST SPEAR
>  M:	Viresh Kumar <viresh.linux@gmail.com>
>  L:	spear-devel@list.st.com
> 


-- 
Nicolas Ferre
