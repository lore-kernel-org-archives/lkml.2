Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1K1JJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:09:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38795 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1K1JJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:09:18 -0500
Message-ID: <4ED34FBF.2020802@igel.co.jp>
Date: Mon, 28 Nov 2011 18:09:19 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lennert Buytenhek <buytenh@marvell.com>, Ben Dooks <ben@simtec.co.uk>,
        Alexey Charkov <alchark@gmail.com>,
        Manuel Lauss <mano@roarinelk.homelinux.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: convert drivers/video/* to use module_platform_driver()
References: <1322274354.10633.3.camel@phoenix>
In-Reply-To: <1322274354.10633.3.camel@phoenix>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/26 11:25, Axel Lin wrote:
> This patch converts the drivers in drivers/video/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Lennert Buytenhek <buytenh@marvell.com>
> Cc: Ben Dooks <ben@simtec.co.uk>
> Cc: Alexey Charkov <alchark@gmail.com>
> Cc: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> Cc: Manuel Lauss <mano@roarinelk.homelinux.net>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/mxsfb.c            |   13 +------------
>  drivers/video/nuc900fb.c         |   13 +------------
>  drivers/video/pxa168fb.c         |   12 +-----------
>  drivers/video/pxa3xx-gcu.c       |   15 +--------------
>  drivers/video/s3c-fb.c           |   13 +------------
>  drivers/video/sh7760fb.c         |   13 +------------
>  drivers/video/sh_mobile_lcdcfb.c |   13 +------------
>  drivers/video/sh_mobile_meram.c  |   13 +------------
>  drivers/video/sm501fb.c          |   13 +------------
>  drivers/video/vt8500lcdfb.c      |   13 +------------
>  drivers/video/w100fb.c           |   13 +------------
>  drivers/video/wm8505fb.c         |   13 +------------
>  drivers/video/wmt_ge_rops.c      |   13 +------------
>  drivers/video/xilinxfb.c         |   20 +-------------------
>  14 files changed, 14 insertions(+), 176 deletions(-)

for sh_mobile_meram.c

Acked-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>

Thanks very much,
