Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2KVS4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:05 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46206 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2KVS4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 23/42] sh-pfc: Add sh7377 pinmux support
Date: Thu, 22 Nov 2012 12:12:18 +0100
Message-ID: <1585278.4IlJHOvdSy@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CABMQnVJU5nfgLzYX9HavNuCxxD5Ei10hbed2Uz1wth-nDse-+Q@mail.gmail.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1353464863-10281-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CABMQnVJU5nfgLzYX9HavNuCxxD5Ei10hbed2Uz1wth-nDse-+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nobuhiro-san,

On Thursday 22 November 2012 13:55:19 Nobuhiro Iwamatsu wrote:
> Hi, Laurent.
> 
> This patch is unnecessary.
> Because support of this CPU is deleted from kernel.
> 
> Best regards,
>   Nobuhiro

Good point, thank you. I'll drop this patch (as well as 21/42) from the 
series.

-- 
Regards,

Laurent Pinchart

