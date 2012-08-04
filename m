Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2HDQvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:51:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2HDQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:51:44 -0400
Message-ID: <501D531D.7050607@canonical.com>
Date: Sat, 04 Aug 2012 18:51:41 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Why is there no nouveau driver maintainer listed in MAINTAINERS?
References: <CAHFgRy_uo2wgFjockPmQgS18X76NxEBAkzJKc_ELTEmhmjuYWA@mail.gmail.com>  <CAFLxGvwapPJthzm6=EzRmrhWRJn5YzKcSomD7GKeTX74zQTdag@mail.gmail.com> <1344097981.4495.6.camel@ayu>
In-Reply-To: <1344097981.4495.6.camel@ayu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 04-08-12 18:33, Calvin Walton schreef:
> On Sat, 2012-08-04 at 17:49 +0200, richard -rw- weinberger wrote:
>> On Sat, Aug 4, 2012 at 5:36 PM, Miles Lane <miles.lane@gmail.com> wrote:
>>> I would like to report an issue in the nouveau driver, but don't know
>>> who to report it to.
>> We have a script for this.
>>
>> rw@raccoon:/media/data1/linux-2.6 (master)>
>> ./scripts/get_maintainer.pl -f ./drivers/gpu/drm/nouveau
>> Ben Skeggs <bskeggs@redhat.com> (commit_signer:399/442=90%)
>> Dave Airlie <airlied@redhat.com> (commit_signer:40/442=9%)
>> Martin Peres <martin.peres@labri.fr> (commit_signer:35/442=8%)
>> linux-kernel@vger.kernel.org (open list)
> In addition, the nouveau driver has its own mailing list, at
> nouveau@lists.freedesktop.org - and they respond to issues on the
> http://bugs.freedesktop.org/ bugzilla.
>

How does this look?

I would like to have feedback from Ben Skeggs and Dave Airlie on this
patch, but would make sense to add nouveau to the maintainers list.

diff --git a/MAINTAINERS b/MAINTAINERS
index fe643e7..791be24 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4828,6 +4828,15 @@ S:	Supported
 F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
 
+NOUVEAU DRIVER
+M:	Ben Skeggs <bskeggs@redhat.com>
+L:	nouveau@lists.freedesktop.org (subscribers-only)
+L:	dri-devel@lists.freedesktop.org
+T:	git git://anongit.freedesktop.org/nouveau/linux-2.6
+S:	Maintained
+F:	drivers/gpu/drm/nouveau/
+F:	include/drm/nouveau_drm.h
+
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev@vger.kernel.org

