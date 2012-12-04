Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2LDVOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:14:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2LDVOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:14:22 -0500
Date: Tue, 4 Dec 2012 22:14:19 +0100
From: Heinz Diehl <htd@fritha.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Lekensteyn <lekensteyn@gmail.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121204211419.GA2724@fritha.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
 <20121204123522.GA32419@fritha.org>
 <1498848.rM1KKK5er8@al>
 <CAKMK7uHH8U64w5kWVp1oOnhTHkStGoJHJx1KazCQ2-gaCAm0Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHH8U64w5kWVp1oOnhTHkStGoJHJx1KazCQ2-gaCAm0Sg@mail.gmail.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:/MzkgtslfaAF6kdHrKB55d5bu8R0fuZ1IZyf1R5K6K8
 fBZBBgnvH3DLSIZAjZdl/PhCJvRJuo2jqpbd4IczG+q4Dr6EMw
 jE2bGi0pxLnt9QjJqoIjLHbQ7KTWrsBcrcUKqpZ43d/iSTtVQp
 1LeEtMQZaqBEkbavPXZhSynrf3cBRLRLNest9niHHu4WWVcts/
 nkxdGnZRkAwGURJ7TqOwCmG3AT8c1mm/6JWZpsodM8FMgxyWm2
 ftRlxBdLSXgURFfDPI7lwqAhYgL9pWApMr9JNMAT0uuM/btQUZ
 gn/VOkIHBvpTZaGsg7IEPAKK33Z+jNykAgFohU+DaiVs3ODhRI
 Mk6ePuuuf23t686OCU8dZeWnH0r4tMe7sEtm0+kq7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012, Daniel Vetter wrote: 

> The important part is to not enable rc6 (on ironlake at least) when
> bisecting.

A shot in the dark: could it be that all the machines wich encounter
this hang have nvidia's optimus? Mine has. Could that somehow be
related? (I'm by no means a programmer or a kernel hacker..).




