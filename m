Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1KDOAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:00:13 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:35278 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab1KDOAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:00:12 -0400
X-Greylist: delayed 2220 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Nov 2011 10:00:12 EDT
Message-ID: <4EB3E733.4000406@iki.fi>
Date: Fri, 04 Nov 2011 15:22:59 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.2-rc1] media updates part 2
References: <4EB3D7FC.7030507@redhat.com>
In-Reply-To: <4EB3D7FC.7030507@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.187.11
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

Could you still try PULL some rather small Anysee changes for 3.2 I have 
requested two weeks ago?
http://patchwork.linuxtv.org/patch/8182/

Those are Common Interface support and new board layout for Anysee E7 T2C.


Antti


On 11/04/2011 02:18 PM, Mauro Carvalho Chehab wrote:
> Hi Linus,
>
> Please pull from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> For:
> 	- move cx25821 out of staging;
> 	  (acked by Greg KH)
> 	- move the remaining media staging drivers to drivers/staging/media;
> 	  (acked by Greg KH)
> 	- a new staging driver at drivers/staging/media: as102;
> 	- a huge pile of patches that will allow soc_camera sensors to be re-used by
> 	  other drivers;
> 	- a new driver for MaxLinear MxL111SF DVB-T devices;
> 	- A new Exynos4 driver (s5k6aa);
> 	- some other random driver fixes, board additions;
> 	- Support for single ITE 9135 devices;
> 	- a few minor improvements needed by some drivers (like adding support for devices
> 	  capable of auto-detecting illumination blinking frequency);
>
> Thanks!
> Mauro

-- 
http://palosaari.fi/
