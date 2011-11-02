Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1KBK6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab1KBK6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:58:33 -0400
Message-ID: <4EB12251.1080405@redhat.com>
Date: Wed, 02 Nov 2011 08:58:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.2-rc1] media drivers/core updates
References: <4EAE976C.3020607@redhat.com> <Pine.LNX.4.64.1111020957580.18080@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1111020957580.18080@axis700.grange>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-11-2011 07:04, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> On Mon, 31 Oct 2011, Mauro Carvalho Chehab wrote:
> 
> Hi Linus,
> 
> Please pull from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> For the latest improvements at the media subsystem, including:
> 	dvb-core: several fixes and addition for DVB turbo delivery system
> 		  (used on North American satellite streams);
> 	dvb-usb: add support for multiple frontends;
> 	ati-remote: migrate to rc-core subsystem;
> 	new dvb-usb drivers:it913x, mxl111sf and pctv452e;
> 	new frontends: a8293, it913x-fe, lnbp22 and tda10071;
> 	Alsa driver for cx23885-based cards;
> 	new gspca driver: topro;
> 	new sensor drivers: mt9p031, mt9t001;
> 	new driver for Samsung SoC s5p fimc;
> 	drivers moved from staging: tda6000 and altera-stapl;
> 	several fixes, card additions and improvements at the existing drivers.
> 
>> Could you, please, confirm, that there's not going to be even an attempt 
>> to push V4L patches from my tree up for 3.2, as requested more than a 
>> month ago:
> 
>> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/38854
> 
>> and re-requested a couple of times since then? It would really be a major 
>> inconvenience to have those patches lying around until 3.3, there are 101 
>> of them, many of them will inevitably fail to apply then. Fixing them 
>> will cause breakage, re-testing on multiple systems with multiple hardware 
>> configurations and in multiple scenarious will be a very time-consuming 
>> operation.

Guennadi,

As I told you during the KS workshop, my intention were to push first the patches
that were already on my tree (and on linux-next) before the beginning of the merge
window. Unfortunately, The email with the instructions to enable my kernel.org account
arrived only after my return back from KS. This delayed my patch submission to start
only this week, on the trees I maintain.

That's said, analyzing a 100+ patch series git request requires me to reserve
a large amount of time to do such task (one day or two?), as it is something I can't
do partially each day. Next time, please don't hold so many patches to be submitted
altogether, but break it into smaller series. It is much easier to analyze 10 series of
10 patches each, sent along the time, than a big series with 100 patches.

I'll still see if I can analyze and merge those patches during this week, but if I can't
merge them up to Thursday, they'll likely be delayed to 3.3, as we won't have time for
sending them to linux-next in time for 3.2 submission.

Regards,
Mauro
