Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2D0MMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:12:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab2D0MMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:12:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] asm-generic: io: don't perform swab during {in,out} string functions
Date: Fri, 27 Apr 2012 12:12:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <1335523376-14695-2-git-send-email-will.deacon@arm.com>
In-Reply-To: <1335523376-14695-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271212.40203.arnd@arndb.de>
X-Provags-ID: V02:K0:OdPQsPu1wOc5ikfr+FEbAor/qBi2cliZrJkkhkz5xep
 fN3y6G0kGlDD02J/JPvf7/445ilvxY1uWGEDDr5dirShyhiurN
 VP9jxmR2zJQOG6kisWWbd3ImH7uS5dxRhFB6OnAocJXETvw48S
 aWes3QYxr78sWep5gGRMTq8hoYvNqHGpFBLzkfwe02gLbDhAqh
 Lzj7iFLF5hGkjs5SIyUW6GCrW9pSSvXXOkQt97+NVVIYKAIWcF
 PL4tMOmUfed+qJcxRqukLJHzRrh/p9jhTzKY6EZYzFD9LntvE7
 hFKKe8TVcTQvjZondUFGUpgeW9VQLexU8FzypwUe62iG0n/ulz
 WZpk0dYY5KpF4ig8YXqY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2012, Will Deacon wrote:
> The {in,out}s{b,w,l} functions are designed to operate on a stream of
> bytes and therefore should not perform any byte-swapping, regardless of
> the CPU byte order.
> 
> This patch fixes the generic IO header so that {in,out}s{b,w,l} call
> the __raw_{read,write} functions directly rather than going via the
> endian-correcting accessors.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
