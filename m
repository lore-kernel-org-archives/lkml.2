Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1ISDv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:51:56 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:60573 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1ISDvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <1316002218-3408-1-git-send-email-per.forlin@linaro.org>
References: <1316002218-3408-1-git-send-email-per.forlin@linaro.org>
Date: Mon, 19 Sep 2011 12:51:54 +0900
Message-ID: <CAC5umyiTrU-6VoaMnsFFqyW7_bJToViOdWbwC04PM9LUSxQkRw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] mmc: rectify boot param option for fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 Per Forlin <per.forlin@linaro.org>:
> Akinobu Mita reported that the boot option for mmc fault injection is never
> compiled in due to a fauly "ifdef KERNEL" that is never set.
> A correct ifdef would be "ifndef MODULE". This patch set adds a
> module_param_cb() and thereby no ifndef MODULE is needed.
> Using a module_param makes it possible to pass default fault attributes for
> external modules too.

All patches look good to me.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
