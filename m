Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1AZAkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:40:52 -0500
Received: from mail.perches.com ([173.55.12.10]:3362 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab1AZAkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:40:51 -0500
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
From: Joe Perches <joe@perches.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
In-Reply-To: <20110125235700.GR8008@google.com>
References: <20110125235700.GR8008@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 16:40:49 -0800
Message-ID: <1296002449.6115.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 15:57 -0800, Mandeep Singh Baines wrote:
> To make it easier to audit dmesg, we'd like to make
> DEFAULT_MESSAGE_LEVEL Kconfig-settable. That way we can set it to
> KERN_NOTICE and audit any messages <= KERN_WARNING.

Seems sensible, but mightn't it be better to make sure
that all printks use a specific KERN_<level> rather
than check that printks without a KERN_<level> are
emitted at a selectable level?


