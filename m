Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1G0QIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:08:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47312 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1G0QIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:08:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ0pr19RWjCJAvnkVR+gL7y8_X4TSFfs7JqXgydWuWMAPPb1ZQ@mail.gmail.com>
References: <1311711119-6286-1-git-send-email-per.forlin@linaro.org>
	<1311711119-6286-3-git-send-email-per.forlin@linaro.org>
	<CAC5umygcfno0-=rA9G0OcxuVK2YK9UokfoYoy45qBT8w0+ytvg@mail.gmail.com>
	<CAJ0pr19RWjCJAvnkVR+gL7y8_X4TSFfs7JqXgydWuWMAPPb1ZQ@mail.gmail.com>
Date: Thu, 28 Jul 2011 01:08:19 +0900
Message-ID: <CAC5umygDP6WCrHmhRqMSDBmnOyB1aw+3nuCqvyz9xGXg9QeePw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mmc: core: add random fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 Per Forlin <per.forlin@linaro.org>:

> There is an issue with patch v4 now when fault_attr is per-host.
> Without your patch the entry is still created at the root but there
> are many instances of fault-attr. I think it's better to wait for your
> patch to make it into the mmc-next tree before submitting my patch. I
> will prepare a patch v5 that depends on your upcoming changes in
> fault-inject with a note that states the dependency.

Or you can prepare a patch for -mm and ask Andrew to add it to the -mm
tree.

> Would you mind adding "patch 1/3" (export_symbol_gpl) to your
> patch-set since it depends on the new function names in your patch?
> If not, I can resend the patch on top of your changes to match the new
> function names if you prefer to have this patch separate.

I recommend it to be a part of your patchset.  The new function name
(fault_create_debugfs_attr) is not likely to change for a time.  You can
add Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
