Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2KZKYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:24:15 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51878 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2KZKYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:24:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jg1.han@samsung.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 1/5] backlight: Add GPIO-based backlight driver
Date: Mon, 26 Nov 2012 11:25:14 +0100
Message-ID: <3031418.vOKE5W8IWc@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <32552643.33371353923376540.JavaMail.weblogic@epv6ml07>
References: <32552643.33371353923376540.JavaMail.weblogic@epv6ml07>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Monday 26 November 2012 09:49:36 Jingoo Han wrote:
> On Saturday, November 24, 2012 1:35 AM, Laurent Pinchart wrote
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> CC'ed Andrew Morton
> 
> It looks good. Also, I tested this patch with SMDK4210 board.
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Thank you.

Unless Richard wants to take 1/5 and 2/5, I plan to push them through either 
the Renesas ARM or Renesas SH tree with the board code patches.

-- 
Regards,

Laurent Pinchart

