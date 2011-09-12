Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1ILQ6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:58:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35152 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755884Ab1ILQ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:58:05 -0400
Subject: Re: [PATCH 10/10] hwspinlock: add MAINTAINERS entries
From: Joe Perches <joe@perches.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Mon, 12 Sep 2011 09:58:04 -0700
In-Reply-To: <1315846025-11453-11-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
	 <1315846025-11453-11-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315846684.31609.1.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 19:47 +0300, Ohad Ben-Cohen wrote:
> Update MAINTAINERS with entries for hwspinlock/core and hwspinlock/omap
> files.

trivial:

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -2953,6 +2953,14 @@ F:	Documentation/hw_random.txt
[]
> +HARDWARE SPINLOCK CORE
> +M:	Ohad Ben-Cohen <ohad@wizery.com>
> +S:	Maintained
> +F:	Documentation/hwspinlock.h

F:	Documentation/hwspinlock.txt

> +F:	drivers/hwspinlock/hwspinlock_core.c
> +F:	drivers/hwspinlock/hwspinlock_internal.h

Maybe
F:	drivers/hwspinlock/hwspinlock_*

> +F:	include/linux/hwspinlock.h


