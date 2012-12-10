Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2LJXUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:20:48 -0500
Received: from wren.arvixe.com ([50.97.138.99]:45624 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab2LJXUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:20:47 -0500
Message-ID: <1355181642.2897.27.camel@localhost>
Subject: Re: [PATCH 4/5] rtl8712: replace min with min_t
From: Przemo Firszt <przemo@firszt.eu>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Dec 2012 23:20:42 +0000
In-Reply-To: <20121210224943.GT22569@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
	 <1355048110-10859-4-git-send-email-przemo@firszt.eu>
	 <20121210094108.GQ6568@mwanda> <1355178112.2897.22.camel@localhost>
	 <20121210224943.GT22569@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2012-12-11, wto o godzinie 01:49 +0300, Dan Carpenter pisze:
[..]
> At the end iwe.u.data.length is going to be a number between 0 and
> 32.  That can easily fit in 16 bits no problem.
> 
> The difference is that, imagine ->network.Ssid.SsidLength is larger
> than u16 like 0x10001.  The cast to u16 changes it to 0x0001 which
> is less than 32 so we would say the minimum is 1 when actually we
> want to say 32 is the min.
> 
Dan,
Thank you! That was the thing that I missed...
New set of patches on the way.
-- 
Kind regards,
Przemo Firszt


