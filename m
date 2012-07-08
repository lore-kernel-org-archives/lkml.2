Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2GHXFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:05:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752390Ab2GHXFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:05:41 -0400
Message-ID: <1341788740.13174.33.camel@joe2Laptop>
Subject: Re: [PATCH 3/3] staging: vt6656: iwctl: remove a few remaining
 redundant newlines
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Sun, 08 Jul 2012 16:05:40 -0700
In-Reply-To: <alpine.LNX.2.00.1207090056180.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>
	 <20120706230945.GA8835@kroah.com>
	 <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1207090056180.15263@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 00:59 +0200, Jesper Juhl wrote:
> I missed a few redundant newlines the first time.
[]
> diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
[]
> @@ -964,7 +964,6 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
>  	wrq->value = pDevice->wRTSThreshold;
>  	wrq->disabled = (wrq->value >= 2312);
>  	wrq->fixed = 1;
> -
>  	return 0;
>  }

I think this is a useful style and these should not be removed.
It's akin to a blank line after automatic variable declarations.

