Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2DSXVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab2DSXU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:20:58 -0400
Message-ID: <4F909DD3.6000403@redhat.com>
Date: Thu, 19 Apr 2012 20:20:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 19 (media/video/mt9m032.c)
References: <20120419164643.d9f918d44c890722b7707508@canb.auug.org.au> <4F909111.9020708@xenotime.net>
In-Reply-To: <4F909111.9020708@xenotime.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-04-2012 19:26, Randy Dunlap escreveu:
> On 04/18/2012 11:46 PM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20120418:
> 
> 
> 
> on x86_64:
> 
>   CC      drivers/media/video/mt9m032.o
> drivers/media/video/mt9m032.c: In function '__mt9m032_get_pad_crop':
> drivers/media/video/mt9m032.c:337:3: error: implicit declaration of function 'v4l2_subdev_get_try_crop'
> drivers/media/video/mt9m032.c:337:3: warning: return makes pointer from integer without a cast
> drivers/media/video/mt9m032.c: In function '__mt9m032_get_pad_format':
> drivers/media/video/mt9m032.c:359:3: error: implicit declaration of function 'v4l2_subdev_get_try_format'
> drivers/media/video/mt9m032.c:359:3: warning: return makes pointer from integer without a cast
> drivers/media/video/mt9m032.c: In function 'mt9m032_probe':
> drivers/media/video/mt9m032.c:767:41: error: 'struct v4l2_subdev' has no member named 'entity'
> drivers/media/video/mt9m032.c:826:38: error: 'struct v4l2_subdev' has no member named 'entity'
> drivers/media/video/mt9m032.c: In function 'mt9m032_remove':
> drivers/media/video/mt9m032.c:842:38: error: 'struct v4l2_subdev' has no member named 'entity'
> make[4]: *** [drivers/media/video/mt9m032.o] Error 1
> 
> Full randconfig file is attached.
> 

This patch should fix it:

	http://git.linuxtv.org/mchehab/media-next.git/commit/18311c5395ca4d0c3fefa406da87a9d16efaca46

It is on my linux-next tree so, if no new conflicts/problems arise, it should be available
on tomorrow's next ;)

Regards,
Mauro
