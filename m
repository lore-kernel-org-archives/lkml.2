Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2IRKCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:02:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16368 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2IRKCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:02:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 18 Sep 2012 03:02:47 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Shubhrajyoti D <shubhrajyoti@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>
Date: Tue, 18 Sep 2012 15:32:42 +0530
Subject: RE: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to
 C99 format
Thread-Topic: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to
 C99 format
Thread-Index: Ac2VhGk8OJLU7rZzRIWJ7fZWpLwqjQAACmyQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDEFB9480@BGMAIL02.nvidia.com>
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
	<1347961843-9376-7-git-send-email-shubhrajyoti@ti.com>
	<D958900912E20642BCBC71664EFECE3E6DDEFB947B@BGMAIL02.nvidia.com>
 <CAM=Q2cv8R8QUbV2UqNO+AbwgprAYxBtBjK=4rkHnqegGJWTdog@mail.gmail.com>
In-Reply-To: <CAM=Q2cv8R8QUbV2UqNO+AbwgprAYxBtBjK=4rkHnqegGJWTdog@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
> Sent: Tuesday, September 18, 2012 3:30 PM
> To: Venu Byravarasu
> Cc: Shubhrajyoti D; linux-media@vger.kernel.org; linux-
> kernel@vger.kernel.org; julia.lawall@lip6.fr
> Subject: Re: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to C99
> format

> >>       struct i2c_msg test[2] = {
> >> -             { client->addr, 0,        3, write },
> >> -             { client->addr, I2C_M_RD, 2, read  },
> >> +             {
> >> +                     .addr = client->addr,
> >> +                     .flags = 0,
> >
> > Does flags not contain 0 by default?
> >
> 
> It does however I felt that 0 means write so letting it be explicit.
> 
> In case a removal is preferred that's doable too however felt it is
> more readable this way.

Though it adds readability, it carries an overhead of one write operation too.
So, better to remove it.
 

