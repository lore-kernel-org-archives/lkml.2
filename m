Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2HBNPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:15:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47026 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2HBNPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:15:07 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 2 Aug 2012 21:14:46 +0800
X-Google-Sender-Auth: cY1BucRt2x3XKFxDuC4leXpTgng
Message-ID: <CAK5ve-LaEXC56iYAc+hCFen2x9Lfscy6Q-z1cCE21UypqpaK3g@mail.gmail.com>
Subject: [overlayfs/bug] LXC ephemeral containers have "/rootfs" prefix in
 /proc/self/maps entries
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kernel-team@lists.ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

We met a LXC issue [1] with overlayfs in Ubuntu, but with aufs it is gone.

I suspect it's related to the issue you mentioned in Documentation of overlayfs:
--
Symlinks in /proc/PID/ and /proc/PID/fd which point to a non-directory
object in overlayfs will not contain vaid absolute paths, only
relative paths leading up to the filesystem's root.  This will be
fixed in the future.
--

Could you please help to take a look at this? or point me out some hints.

[1], https://bugs.launchpad.net/ubuntu/+source/linux/+bug/959352

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
