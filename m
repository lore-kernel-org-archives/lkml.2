Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab0HRM2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:28:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0HRM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:28:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Wed, 18 Aug 2010 14:28:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <4C61EE55.5030506@codeaurora.org> <1282094950-6184-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1282094950-6184-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181428.45029.arnd@arndb.de>
X-Provags-ID: V02:K0:/opFxcEPkRQ+cb1cpTsyymQVwp1v1Hv3AVwruoXlh/8
 VYA5Z1XnSGW6bLL3qY3vtI/G9dpUN1VR37/CTpaxjGlYD9T9tb
 01GkD5o8qtAjFTVh5WGnbVFpSoDaeHezn/mP8e1ZLeYNKPjBtC
 pvbNVkxtCfFo4Lx/54AY6SrNfn5rcJL7gKkIgm+5+cn4rUYC+P
 55ot+YCCRBgncZbl+KsNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 August 2010, Stephen Boyd wrote:
> 
> I'm unsure what needs to be done for the follow up patch. Shouldn't
> it be multiple patches sent to each arch maintainer to fix the
> wording?

No, that will just result in half of them applying it, best make 
a single patch and send it to linux-arch@vger.kernel.org for review.

It's probably best to move the config option to lib/Kconfig.debug
so it only appears once, and make it depend on DEBUG_USER_COPY_CHECKS,
which is then unconditionally defined by the architectures that want it.

	Arnd
