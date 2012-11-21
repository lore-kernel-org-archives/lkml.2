Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2KURDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:03:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2KURDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:03:12 -0500
Message-ID: <50AD0936.9060603@canonical.com>
Date: Wed, 21 Nov 2012 12:02:46 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, David Airlie <airlied@linux.ie>,
        Kelly Doran <kel.p.doran@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [3.7-rc5/rc6 regression] "drm/nvc0/disp: fix regression in vblank
 semaphore release" broke nouveau driver and mplayer
References: <20647.59126.898316.299551@pilspetsen.it.uu.se> <20121117220342.GB23587@joi.lan>
In-Reply-To: <20121117220342.GB23587@joi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2012 05:03 PM, Marcin Slusarz wrote:
> On Sat, Nov 17, 2012 at 08:35:18PM +0100, Mikael Pettersson wrote:
>> mplayer worked fine on my Dell Latitude E6510 (nVidia GT218 [NVS 3100M] graphics)
>> up to and including kernel 3.7-rc4. However, with 3.7-rc5 or -rc6, any attempt to
>> run mplayer just blanks the screen, shows some stray white pixels in the upper left
>> corner, kills the X server, and spews the following errors from the kernel:
> Fix was already posted and should be merged soon.
>
> http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=7a259e65569bd7593ad541c84982027969ec9c45
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Do you happen to know if this fix will make it into 3.7, or do you think 
it won't happen until 3.8?

Thanks,

Joe
