Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1EFNWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:22:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab1EFNWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:22:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
Date: Fri, 6 May 2011 15:22:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dave Jones <davej@redhat.com>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061522.33179.arnd@arndb.de>
X-Provags-ID: V02:K0:XU/Z7N2dZc7K2q4vWPyxuhLhvmOfUCBK+PtFwKD70lv
 87oaDBbx8dv1M7wMJ49KVCPzBEmunlJx8leYiqm9u4SuHz/TRY
 bnhiv24H5QWpfy6GBzKhWuQKjf4nX3uG5uqwk97CCxMmfS2Ga2
 sRqsxBPceZv7HAuNK/xDWQw8zavQuAo0r1wop+g70NKX/56M3i
 2uzcjvSEAao3n4T0zXrJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 May 2011, Linus Walleij wrote:
> 
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This updates the ux500 cpufreq driver to the new interface from the
> updated DB8500 PRCMU driver and moves it to drivers/cpufreq as
> discussed with Dave Jones.
> 
> The Makefile change in drivers/cpufreq will collide with Daves commit
> moving cpufreq drivers into drivers/cpufreq/*, this needs to be fixed up
> in next or the merge window since this driver depend deeply on other
> changes in this patchset and GPIO consolidation.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dave Jones <davej@redhat.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Looks good for all I can tell, but please split this into two patches,
one for the conversion to the new interface and one for the actual
move. That would make it possible to review the changes you did.

	Arnd
