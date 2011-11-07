Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1KGMZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:25:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1KGMZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:25:36 -0500
Message-ID: <4EB7CE34.2050409@redhat.com>
Date: Mon, 07 Nov 2011 10:25:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.2-rc1] media updates part 2
References: <4EB3D7FC.7030507@redhat.com> <4EB3E733.4000406@iki.fi>
In-Reply-To: <4EB3E733.4000406@iki.fi>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-11-2011 11:22, Antti Palosaari escreveu:
> Mauro,
> 
> Could you still try PULL some rather small Anysee changes for 3.2 I have requested two weeks ago?
> http://patchwork.linuxtv.org/patch/8182/
> 
> Those are Common Interface support and new board layout for Anysee E7 T2C.

Sorry, but it is very likely to merge them for 3.3. I doubt that we still would have time
to push this into -next and merge upstream.

Regards,
Mauro
> 
> 
> Antti
> 
> 
> On 11/04/2011 02:18 PM, Mauro Carvalho Chehab wrote:
>> Hi Linus,
>>
>> Please pull from:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>>
>> For:
>>     - move cx25821 out of staging;
>>       (acked by Greg KH)
>>     - move the remaining media staging drivers to drivers/staging/media;
>>       (acked by Greg KH)
>>     - a new staging driver at drivers/staging/media: as102;
>>     - a huge pile of patches that will allow soc_camera sensors to be re-used by
>>       other drivers;
>>     - a new driver for MaxLinear MxL111SF DVB-T devices;
>>     - A new Exynos4 driver (s5k6aa);
>>     - some other random driver fixes, board additions;
>>     - Support for single ITE 9135 devices;
>>     - a few minor improvements needed by some drivers (like adding support for devices
>>       capable of auto-detecting illumination blinking frequency);
>>
>> Thanks!
>> Mauro
> 

