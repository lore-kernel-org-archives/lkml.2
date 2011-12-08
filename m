Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1LHJyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:54:06 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56843 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1LHJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:54:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [PATCH] [media] omap3isp: fix compilation of ispvideo.c
Date: Thu, 8 Dec 2011 10:53:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
References: <1321808066-1791-1-git-send-email-mad_soft@inbox.ru> <201111230253.21007.laurent.pinchart@ideasonboard.com> <CADMYwHzPJeu6ixNJ=uRVEF-wz7Uz4oYdfHme8g1sRAK20Cro0w@mail.gmail.com>
In-Reply-To: <CADMYwHzPJeu6ixNJ=uRVEF-wz7Uz4oYdfHme8g1sRAK20Cro0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112081054.01240.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Thursday 08 December 2011 07:31:29 Ohad Ben-Cohen wrote:
> On Wed, Nov 23, 2011 at 3:53 AM, Laurent Pinchart wrote:
> > On Sunday 20 November 2011 17:54:26 Dmitry Artamonow wrote:
> >> Fix following build error by explicitely including <linux/module.h>
> >> header file.
> >> 
> >>   CC      drivers/media/video/omap3isp/ispvideo.o
> >> drivers/media/video/omap3isp/ispvideo.c:1267: error: 'THIS_MODULE'
> >> undeclared here (not in a function) make[4]: ***
> >> [drivers/media/video/omap3isp/ispvideo.o] Error 1
> >> make[3]: *** [drivers/media/video/omap3isp] Error 2
> >> make[2]: *** [drivers/media/video] Error 2
> >> make[1]: *** [drivers/media] Error 2
> >> make: *** [drivers] Error 2
> >> 
> >> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Mauro, can you pick this for v3.2, or would you like me to send a pull
> > request ?
> 
> Folks, was this one picked up by anyone ?
> 
> We seem to still have this issue in mainline (at least in rc4).

According to http://patchwork.linuxtv.org/patch/8510/ the patch has been 
accepted. Mauro, do you have any time estimate regarding when you will push 
that to Linus ?

-- 
Regards,

Laurent Pinchart
