Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2JUIym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 04:54:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2JUIyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 04:54:41 -0400
Date: Sun, 21 Oct 2012 10:54:34 +0200
From: Heinz Diehl <htd@fritha.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Martin Peres <martin.peres@labri.fr>, Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121021085434.GA2403@fritha.org>
References: <1724445.dN2yMEzN6d@localhost>
 <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
 <20121020092647.GA3186@fancy-poultry.org>
 <50827174.7070109@labri.fr>
 <20121020104238.GA1539@fritha.org>
 <20121020202846.GA5826@joi.lan>
 <20121020212036.GA1698@fritha.org>
 <20121020214217.GC5826@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020214217.GC5826@joi.lan>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:RCYtuYpD8sVG6dC0VkiFuZSxevHluSivg25LMwfwMk4
 1mlgdSUtXPnlhYJL1O6acsLlLU9j4FhQcIh1kuEOPBkOOC0tbY
 HlDI3PVM5umHL60JQzGvjDMCBMIXLSe21hisheVloY9brcCuaw
 RI+Qc3DWO2W16qf7FqLfhY5d3EAPj4MHZBdD8FCNCjdRMGISNG
 mEoQhaZiu+9agbUDO4eqlBXIxaReNJE3NV0bodjBGbhHwYA+X8
 E2Smk+a9J1enHAfvNqr/+OhHdi0DNXicvEypcV7IkKUWN+piwz
 nDXL5PPEWORcDhlZK5YaNMHwZSxr0V8dWQPvPA4c+wBVqX4WDW
 RiSHaVO9UGt4Xlaw3PEw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2012, Marcin Slusarz wrote: 

> On 3.6 kernel? (It doesn't exist on 3.7)
> Note that it may be in other directory than "0".

[root@wildsau linux-3.6.2]# cat .config | grep -i "nouveau"
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

I grepped the whole disk, there's no vbios.rom at all.

