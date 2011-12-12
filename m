Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1LLRum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:50:42 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:59494 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1LLRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:50:40 -0500
X-Greylist: delayed 2681 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 12:50:39 EST
Message-ID: <4EE6346D.6060801@iki.fi>
Date: Mon, 12 Dec 2011 19:05:49 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.2-rc5] media fixes
References: <4EE63039.4040004@redhat.com>
In-Reply-To: <4EE63039.4040004@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.185.170
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 06:47 PM, Mauro Carvalho Chehab wrote:
> Hi Linus,
>
> Please pull from:
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
> v4l_for_linus
>
> For a couple fixes for media drivers.
> The changes are:
> - ati_remote (new driver for 3.2): Fix the scancode tables;
> - af9015: fix some issues with firmware load;
> - au0828: (trivial) add device ID's for some devices;
> - omap3 and s5p: several small fixes;
> - Update MAINTAINERS entry to cover /drivers/staging/media and
> media DocBook;
> - a few other small trivial fixes.
>
> Thanks!
> Mauro
>
> -
>
> The following changes since commit
> dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:
>
> Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)
>
> are available in the git repository at:
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
> v4l_for_linus
>

> Antti Palosaari (3):
> [media] af9015: limit I2C access to keep FW happy

Hey, now there is misunderstanding. I don't want that patch to be 3.2. 
It is surely kinda a bug fix, but I see it too risky at that phase. 
Please delay that for the 3.3 and apply with my latest af9013 rewrite.

> [media] tda18218: fix 6 MHz default IF frequency
> [media] mxl5007t: fix reg read

regards
Antti
-- 
http://palosaari.fi/
