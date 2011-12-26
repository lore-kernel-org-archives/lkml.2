Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1LZRTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:19:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51273 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1LZRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:19:23 -0500
Message-ID: <4EF8AC83.9040705@lwfinger.net>
Date: Mon, 26 Dec 2011 11:18:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: support new RX header, noticed to be used in 598.314+
 fw
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2011 09:29 AM, Guennadi Liakhovetski wrote:
> Hi
>
> Sorry for "simulating" a reply - I'm not subscribed to linux-wireless, so,
> cannot (easily) reply.
>
> The commit in subject line
>
> commit 17030f48e31adde5b043741c91ba143f5f7db0fd
> From: Rafa³ Mi³ecki<zajec5@gmail.com>
> Date: Thu, 11 Aug 2011 17:16:27 +0200
> Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw
>
> breaks my b43 SDIO card in 3.2-ish kernels. Given the approaching
> 3.2-final release, would be nice to have it fixed before that. The card
> I've got is marked with some "SD-Link11g" from some "C-guys, Inc." from
> Taiwan:-) Using firmware version 410.31754. Do I really _have_ to update
> or is the driver supposed to handle "all" firmware versions, or at least
> not drop ones, it used to support before?

The only cards that *need* to use the new-style firmware are those for which 
firmware does not exist in the older versions. As this is not the case for your 
device, something else is wrong.

Please post the details for your card. If you had a PCI system, I would ask for 
'lspci -n'. Please do the same for the SDIO card.

 From your message, it appears that 3.1 works OK. If that is true, would it be 
possible for you to bisect this problem?

Larry
