Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2EMP0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:26:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53962 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2EMP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:26:15 -0400
MIME-Version: 1.0
Date: Sun, 13 May 2012 20:56:13 +0530
Message-ID: <CAFDqYy0DCh-v-PUv-uNR6rM1kv3RZ0O_A6kH1O2K3uZnGqLt6A@mail.gmail.com>
Subject: warning: DRM selects DMA_SHARED_BUFFER when ran make randconfig
From: joseph daniel <josephdanielwalter@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There was some warning when ran "make randconfig ".

warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct
dependencies (EXPERIMENTAL).

so i was thinking of the possible fix may be

drivers/gpu/drm/Kconfig


+ select DMA_SHARED_BUFFER if EXPERIMENTAL

Thanks
