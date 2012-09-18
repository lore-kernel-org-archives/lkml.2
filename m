Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2IRKAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:00:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59459 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2IRKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:00:03 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <1346351174-28441-1-git-send-email-fernando.lugo@ti.com>
References: <1346351174-28441-1-git-send-email-fernando.lugo@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 18 Sep 2012 12:59:42 +0300
Message-ID: <CAK=WgbaoPMj9OobHuC=VObTjvT--faen2_rfY-s4Jk-+Fqi5iQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] remoteproc: introduce rproc recovery
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

On Thu, Aug 30, 2012 at 9:26 PM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> These set of patches make possible the remoteproc recover after a crash.
> This is a hard recovery, that means the remoteproc is reset and it will
> start from the beginning. When a crash happen all the virtio devices are
> destroyed. Therefore, both rpmsg drivers and devices are gracefully
> removed which also cause rproc users become 0 and the remoteproc is turned
> off. After the virtio devices are destroyed the crash handler function
> will read the virtio information from the firmware in order to recreate
> the virtio devices that will boot the remoteproc and everything will be
> functional again.

Applied to remoteproc's for-next branch with a few changes (so we
don't miss the merge window).

The changes are detailed in the commit logs of the patches, please let
me know if there's any issue.

Thanks!
Ohad.
