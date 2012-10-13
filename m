Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2JMKc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 06:32:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47202 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2JMKcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 06:32:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, backports@vger.kernel.org, rob@ti.com,
        arnd@arndb.de, davej@redhat.com, airlied@linux.ie, bskeggs@redhat.com,
        alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, tglx@linutronix.de,
        daniel.vetter@ffwll.ch, jbarnes@virtuousgeek.org,
        alexander.deucher@amd.com, paulmck@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] uapi: update includes for drm content when no kernel API exists
Date: Sat, 13 Oct 2012 12:33:32 +0200
Message-ID: <3084988.3Xup6S3alX@avalon>
User-Agent: KMail/4.9.2 (Linux/3.4.9-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1350085772-8755-2-git-send-email-mcgrof@do-not-panic.com>
References: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com> <1350085772-8755-2-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Friday 12 October 2012 16:49:31 Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> The UAPI changes split kernel API and userspace API
> content onto two separate header files. The userspace
> API drm content was moved to include/uapi/drm/ with the
> same file name while kernel specific API content was
> kept under include/drm/ with the same file name. When
> one file was split into two files the kernel header
> includes the uapi header and a UAPI prefix was added to
> the uapi header for its header guard. When there was no
> kernel API content found the uapi header file was the
> only one that was kept and the original guard for the
> header file was kept. In this particular case the
> original users of this header file were not modified
> and the uapi header file is expected to be picked up
> by path.
> 
> This may work well at compilation on the kernel but when
> backporting this creates a few complexities.

Could you please provide more details about those complexities ?

> To help with
> backporting [0] lets be explicit about the new uapi path
> when there is no respective kernel API header file. For
> more details on the UAPI changes see the lwn article on
> this [1].
> 
> [0] https://backports.wiki.kernel.org
> [1] http://lwn.net/Articles/507794/
> 
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: backports@vger.kernel.org
> 
> Cc: Rob Clark <rob@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dave Jones <davej@redhat.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

-- 
Regards,

Laurent Pinchart

