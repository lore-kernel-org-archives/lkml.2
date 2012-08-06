Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2HFGls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:41:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54659 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2HFGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120727133952.2036.61330.stgit@patser.local>
References: <20120727133952.2036.61330.stgit@patser.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 6 Aug 2012 12:11:25 +0530
Message-ID: <CAO_48GGBdb4D+YMS4NYVPxxhUrHLcQdZEpi_rmypoGPXYtAyrg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] dma-fence: dma-buf synchronization (v5)
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linaro-mm-sig@lists.linaro.org, rob.clark@linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten,
On 27 July 2012 19:09, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> A dma-fence can be attached to a buffer which is being filled or consumed
> by hw, to allow userspace to pass the buffer without waiting to another
> device.  For example, userspace can call page_flip ioctl to display the
> next frame of graphics after kicking the GPU but while the GPU is still
> rendering.  The display device sharing the buffer with the GPU would
> attach a callback to get notified when the GPU's rendering-complete IRQ
> fires, to update the scan-out address of the display, without having to
> wake up userspace.
Since Rob is the original author of this (and I the next?), may I
request you to re-submit with his "From:" bit?

Rob / Daniel: comments on this series will help me line it up in
for-next, and maybe even for 3.7-rc.

Best regards,
~Sumit.
<snip>
