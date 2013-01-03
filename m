Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3ACBFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:05:21 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:39032 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3ACBFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:05:20 -0500
MIME-Version: 1.0
In-Reply-To: <CADnq5_OBpEogK2FCof16NoZts9ieDQYJdTJjqZptkL2K4GaZ_A@mail.gmail.com>
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
	<20130102223807.GA242@x4>
	<CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
	<CAKocOOMx4nLFXfbE95WxsJ7j3mFf_GPWxcmMxqHbMh8tBgULWw@mail.gmail.com>
	<CADnq5_OBpEogK2FCof16NoZts9ieDQYJdTJjqZptkL2K4GaZ_A@mail.gmail.com>
Date: Wed, 2 Jan 2013 18:05:18 -0700
Message-ID: <CAKocOOOnoULBS6M66MaoXOEXcFTHS1hL0pJtXkjXqYyB1tE04w@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Shuah Khan <shuahkhan@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jerome Glisse <j.glisse@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Borislav Petkov <bp@alien8.de>, Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 4:59 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>>
>>
>> Catching up with this thread. I reverted the
>>
>> drm/radeon: use async dma for ttm buffer moves on 6xx-SI
>> commit id: 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2
>>
>> Do I need to apply this patch without reverting
>> 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2?
>
> Correct.  Don't revert anything.  Just apply this patch.
>
> Alex

Alex,

Your patch fixed the problem I was seeing.

-- Shuah
