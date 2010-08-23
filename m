Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0HWIPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:15:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41352 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0HWIPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Y8uax+7iBRbpqMe55DODx1W+QZTlFsu67yq/7aRkCeqpFCf5JmPVB6x/sGIun/clQE
         XLcjuKUTSzD6sUlCQS9v82uuUPJyljBb2SgGsgDgxAEpM6nEG6EJm4xl/Y+rk02K9Og8
         icGeUTyVt0IyXxjnTT6RuYgBTlE1KblEJCDlA=
Date: Mon, 23 Aug 2010 10:15:57 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/1] introduce a syscall for posix clock tuning
Message-ID: <cover.1282550649.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently on lkml, we discussed adding a new syscall, with the
motivation of supporting PTP clocks. Here is my suggestion how this
should look like. I would like to get some agreement about this new
interface before proceeding with the PTP stuff itself.

Thanks,
Richard

Richard Cochran (1):
  posix clocks: introduce syscall for clock tuning.

 arch/arm/include/asm/unistd.h      |    1 +
 arch/arm/kernel/calls.S            |    1 +
 arch/blackfin/include/asm/unistd.h |    3 +-
 arch/blackfin/mach-common/entry.S  |    1 +
 arch/powerpc/include/asm/systbl.h  |    1 +
 arch/powerpc/include/asm/unistd.h  |    3 +-
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 +-
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/linux/posix-timers.h       |    5 ++++
 include/linux/syscalls.h           |    3 ++
 kernel/compat.c                    |   20 ++++++++++++++++++
 kernel/posix-cpu-timers.c          |    5 ++++
 kernel/posix-timers.c              |   38 ++++++++++++++++++++++++++++++++++++
 15 files changed, 85 insertions(+), 3 deletions(-)

