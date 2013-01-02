Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3ABWiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:38:13 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:36652 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3ABWiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:38:11 -0500
Date: Wed, 2 Jan 2013 23:38:07 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, Borislav Petkov <bp@alien8.de>,
        Shuah Khan <shuahkhan@gmail.com>, Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130102223807.GA242@x4>
References: <20121223113153.GA8918@liondog.tnic>
 <20121223115133.GA229@x4>
 <20121223122210.GA4460@liondog.tnic>
 <20121223133102.GA8153@liondog.tnic>
 <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
 <50E3907C.4040106@iki.fi>
 <20130102120248.GC6181@x1.alien8.de>
 <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
 <50E4755E.7030209@iki.fi>
 <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
> Please affected people can you test if patch :
> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch
> 
> Fix the issue, you need to make sure you don't have the patch that
> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
> is :
>  .copy = &r600_copy_dma,
>  .copy_ring_index = R600_RING_TYPE_DMA_INDEX,

It fixes the issue for me. Thanks.

-- 
Markus
