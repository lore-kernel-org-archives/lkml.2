Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1HVH1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 03:27:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48495 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1HVH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 03:27:37 -0400
Message-ID: <4E5204E3.7070107@suse.cz>
Date: Mon, 22 Aug 2011 09:27:31 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: ia64 build broken on CONFIG_DEBUG_STACK_USAGE
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when CONFIG_DEBUG_STACK_USAGE is selected, I get these errors:
  CC      arch/ia64/kernel/asm-offsets.s
In file included from arch/ia64/kernel/asm-offsets.c:9:
include/linux/sched.h: In function ‘stack_not_used’:
include/linux/sched.h:2419: error: ‘IA64_TASK_SIZE’ undeclared (first
use in this function)
include/linux/sched.h:2419: error: (Each undeclared identifier is
reported only once
include/linux/sched.h:2419: error: for each function it appears in.)
include/linux/sched.h:2419: error: ‘IA64_THREAD_INFO_SIZE’ undeclared
(first use in this function)
make[1]: *** [arch/ia64/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

regards,
-- 
js
suse labs
