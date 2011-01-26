Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1AZVkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:40:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1AZVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:40:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Date: Wed, 26 Jan 2011 22:39:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>
References: <20110123011221.GB1805@nowhere> <alpine.LSU.2.00.1101232246380.3691@sister.anvils> <849307$b9dvii@azsmga001.ch.intel.com>
In-Reply-To: <849307$b9dvii@azsmga001.ch.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101262239.57585.arnd@arndb.de>
X-Provags-ID: V02:K0:8H1+uexhI6DnRlI2OcksKEynTFDTiBSn/GJqmgW4QEh
 aH+LOW5gnoITHrg6n+cPw+G77eg1jo8PXm130TvveS+S3uBt4p
 FmXB0rIzIHnQx4PGLUlkq/yDxN7tWBJpmfB0NfHYkq8y1Hq70w
 56870rd/Pl6xnS9ItsHX8ONZ7Ja6kROgh0r6YHK8PDgxZV1y0M
 SdbePiz1iTDvpMqtnK+lA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 January 2011 11:10:20 Chris Wilson wrote:
> The patch I finally applied did include those fixes. After making the
> mistake once, I had to double check the other call sites.

Not sure which repository you applied it to, but 2.6.38-rc2 with the two
patches applied works for me.

Tested-by: Arnd Bergmann <arnd@arndb.de>
