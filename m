Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2ATRAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:00:36 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43674 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612Ab2ATRAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:00:34 -0500
MIME-Version: 1.0
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Fri, 20 Jan 2012 22:30:09 +0530
Message-ID: <CAB2ybb8rH7pdV-M_NdoPvWKvH78GRugie+tbnbt39oCcCENv=w@mail.gmail.com>
Subject: [GIT PULL]: dma-buf tree: maintainer update
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org
Cc: akpm@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Jesse Barker <jesse.barker@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Post the merge of dma-buf tree that was (very kindly) sent by Dave
Airlie, various people involved in this project feel it is natural and
practical for me to be the maintainer of this code.

This is my first pull request to you, which only changes the
MAINTAINERS file - could you please pull from it? [If you'd just
prefer the patch, I could post that out as well.]

Thanks and best regards,
~Sumit.

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git for-linus-3.3

Sumit Semwal (1):
      MAINTAINERS: Add dma-buf sharing framework maintainer

 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
