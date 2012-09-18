Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab2IRKAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:00:37 -0400
Received: from ams-iport-3.cisco.com ([144.254.224.146]:42981 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2IRKAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:00:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAJBFWFCQ/khR/2dsb2JhbABFhge2K4EHgiABAQEEEgEQVhALGAICJgICVwYTIodeC5oujRuTHYEhigAahTyBEgOVYo44gWmCaIFh
X-IronPort-AV: E=Sophos;i="4.80,442,1344211200"; 
   d="scan'208";a="8118867"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCHv2 0/6] media: convert to c99 format
Date: Tue, 18 Sep 2012 12:00:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181200.20788.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18 September 2012 11:50:37 Shubhrajyoti D wrote:
> The series tries to convert the i2c_msg to c99 struct.
> This may avoid issues like below if someone tries to add an
> element to the structure.
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
> 
> Special thanks to Julia Lawall for helping it automate.
> By the below script.
> http://www.mail-archive.com/cocci@diku.dk/msg02753.html

That looks much better.

For the whole series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> 
> 
> Shubhrajyoti D (6):
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
>   media: Convert struct i2c_msg initialization to C99 format
> 
>  drivers/media/i2c/ks0127.c                    |   14 +++++++-
>  drivers/media/i2c/msp3400-driver.c            |   42 +++++++++++++++++++++---
>  drivers/media/i2c/tvaudio.c                   |   14 +++++++-
>  drivers/media/radio/radio-tea5764.c           |   14 ++++++--
>  drivers/media/radio/saa7706h.c                |   16 ++++++++-
>  drivers/media/radio/si470x/radio-si470x-i2c.c |   24 ++++++++++---
>  6 files changed, 103 insertions(+), 21 deletions(-)
> 
> 
