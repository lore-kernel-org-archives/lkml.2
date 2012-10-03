Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2JCMQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:16:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:59214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab2JCMQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="scan'208";a="229409832"
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 06/13] scripts/gdb: Add lx-dmesg command
References: <cover.1349263293.git.jan.kiszka@web.de>
	<805b20bb0e1fb1ec06acf8e50237cdb40dd54290.1349263293.git.jan.kiszka@web.de>
Date: Wed, 03 Oct 2012 05:16:07 -0700
In-Reply-To: <805b20bb0e1fb1ec06acf8e50237cdb40dd54290.1349263293.git.jan.kiszka@web.de>
	(Jan Kiszka's message of "Wed, 3 Oct 2012 13:21:37 +0200")
Message-ID: <m2iparwy2g.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka <jan.kiszka@web.de> writes:

> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> This pokes into the log buffer of the debugged kernel, dumping it to the
> gdb console. Helping in case the target should or can no longer execute
> dmesg itself.

Thanks. That's very useful. I recently ran into this problem that
the new log buffer is a pain to dump from qemu gdb.

fwiw there's already some kdump macros in Documentation/kdump 
Since you obsoleted them you could remove those (and for log buffer
they do not work anymore)

I don't like the lx-* prefixes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
