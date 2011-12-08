Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1LHGbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:31:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1LHGbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:31:53 -0500
MIME-Version: 1.0
In-Reply-To: <201111230253.21007.laurent.pinchart@ideasonboard.com>
References: <1321808066-1791-1-git-send-email-mad_soft@inbox.ru> <201111230253.21007.laurent.pinchart@ideasonboard.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Dec 2011 08:31:29 +0200
X-Google-Sender-Auth: aeNaW55SpnhLXPbwYDr5ycA3aKo
Message-ID: <CADMYwHzPJeu6ixNJ=uRVEF-wz7Uz4oYdfHme8g1sRAK20Cro0w@mail.gmail.com>
Subject: Re: [PATCH] [media] omap3isp: fix compilation of ispvideo.c
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 3:53 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Sunday 20 November 2011 17:54:26 Dmitry Artamonow wrote:
>> Fix following build error by explicitely including <linux/module.h>
>> header file.
>>
>>   CC      drivers/media/video/omap3isp/ispvideo.o
>> drivers/media/video/omap3isp/ispvideo.c:1267: error: 'THIS_MODULE'
>> undeclared here (not in a function) make[4]: ***
>> [drivers/media/video/omap3isp/ispvideo.o] Error 1
>> make[3]: *** [drivers/media/video/omap3isp] Error 2
>> make[2]: *** [drivers/media/video] Error 2
>> make[1]: *** [drivers/media] Error 2
>> make: *** [drivers] Error 2
>>
>> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Mauro, can you pick this for v3.2, or would you like me to send a pull request
> ?

Folks, was this one picked up by anyone ?

We seem to still have this issue in mainline (at least in rc4).

Thanks,
Ohad.
