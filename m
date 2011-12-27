Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1L0M13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 07:27:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47062 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1L0M11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 07:27:27 -0500
MIME-Version: 1.0
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 27 Dec 2011 20:27:05 +0800
Message-ID: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
Subject: re: [PATCH] PM / Hibernate: Improve performance of LZO/plain
 hibernation, checksum image
To: bojan@rexursive.com, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use threads for LZO compression/decompression on hibernate/thaw.
> Improve buffering on hibernate/thaw.
> Calculate/verify CRC32 of the image pages on hibernate/thaw.

> In my testing, this improved write/read speed by a factor of about two.

> Signed-off-by: Bojan Smojver <bojan@rexursive.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

hi Bojan,
this patch is definitely great!
any plan to write the same patch for decompress and restore? i think
that is probably more important than compression and hibernation to
improve bootup speed.

Thanks
barry
