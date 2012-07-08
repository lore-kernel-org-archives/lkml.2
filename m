Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GHXDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:03:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42436 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752237Ab2GHXDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:03:47 -0400
Message-ID: <1341788626.13174.31.camel@joe2Laptop>
Subject: Re: [PATCH 1/3] staging: vt6656: iwctl: fix up spacing around
 operators
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Sun, 08 Jul 2012 16:03:46 -0700
In-Reply-To: <alpine.LNX.2.00.1207090054270.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>
	 <20120706230945.GA8835@kroah.com>
	 <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1207090054270.15263@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 00:58 +0200, Jesper Juhl wrote:
> A few cases were missed in my previous cleanup, this takes care of the
> last cases of missing space (or too much space (as in a newline))
> around operators ('=', '==', ',', '<').

Trivia:

> diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
[]
> @@ -1624,8 +1624,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
>  	case IW_MLME_DISASSOC:
>  		if (pDevice->bLinkPass == TRUE) {
>  			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
> -			bScheduleCommand((void *)pDevice,
> -					WLAN_CMD_DISASSOCIATE,
> +			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE,
>  					NULL);

pDevice doesn't need a cast.

bScheduleCommand uses a lot of casts for pDevice
that aren't necessary.



