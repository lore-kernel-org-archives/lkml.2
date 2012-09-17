Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2IQPjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:39:43 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2915 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2IQPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:39:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCH 0/6] media: input: convert to c99 format
Date: Mon, 17 Sep 2012 17:37:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
References: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171737.51989.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon September 17 2012 17:22:27 Shubhrajyoti D wrote:
> The series tries to convert the i2c_msg to c99 struct.
> This may avoid issues like below if someone tries to add an
> element to the structure.
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html

I'm OK with this provided that these intializations are formatted with
one field per line. It's rather hard to read otherwise since the lines
are now a lot longer.

Regards,

	Hans

> Special thanks to Julia Lawall for helping it automate.
> By the below script.
> http://www.mail-archive.com/cocci@diku.dk/msg02753.html
> 
> Checkpatch warn of more than 80 chars have been ignored.
> 
> Shubhrajyoti D (6):
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
> 
>  drivers/media/i2c/ks0127.c                    |    4 ++--
>  drivers/media/i2c/msp3400-driver.c            |   12 ++++++------
>  drivers/media/i2c/tvaudio.c                   |    4 ++--
>  drivers/media/radio/radio-tea5764.c           |    6 +++---
>  drivers/media/radio/saa7706h.c                |    4 ++--
>  drivers/media/radio/si470x/radio-si470x-i2c.c |   12 ++++++------
>  6 files changed, 21 insertions(+), 21 deletions(-)
> 
> 
