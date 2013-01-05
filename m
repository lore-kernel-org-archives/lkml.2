Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3AEMNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 07:13:30 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:41425 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3AEMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 07:13:28 -0500
X-Greylist: delayed 165706 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2013 07:13:27 EST
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 5 Jan 2013 13:13:27 +0100
Message-ID: <CA+icZUUxgRsGkYAmZ=JxTwPvdhTzpGLcxm6+VSq9jnfYPVXj4Q@mail.gmail.com>
Subject: Re: 3.8-rc2 lockdep complains about console_lock vs. fb_notifier_list.rwsem
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

...known issue (see thread in [1]), please feel free to test patches
from Alan and Andrew (see [1], [2] and [3]) and report.

Regards,
- Sedat -

[1] http://marc.info/?t=135309396400003&r=1&w=2
[2] http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
[3] http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
[4] http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
