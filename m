Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1I1W3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:29:36 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:53486 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752436Ab1I1W3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:29:33 -0400
Message-ID: <4E839FCB.7050403@xenotime.net>
Date: Wed, 28 Sep 2011 15:29:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 28 (media/video/mt9p031.c)
References: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au>
In-Reply-To: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/11 03:04, Stephen Rothwell wrote:
> Hi all,


a.  Source file needs <linux/module.h> added to it unless the dropping
of the moduleh tree for today already contained that patch.

b.  Build errors after adding <linux/module.h>:

when CONFIG_MEDIA_CONTROLLER is not enabled
and CONFIG_VIDEO_V4L2_SUBDEV_API is not enabled:


drivers/media/video/mt9p031.c:443:3: error: implicit declaration of function 'v4l2_subdev_get_try_format'
drivers/media/video/mt9p031.c:457:3: error: implicit declaration of function 'v4l2_subdev_get_try_crop'
drivers/media/video/mt9p031.c:888:42: error: 'struct v4l2_subdev' has no member named 'entity'


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
