Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab1IHDo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:44:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186Ab1IHDoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <web-603103654@zbackend1.aha.ru>
References: <web-603103654@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Sep 2011 20:44:29 -0700
Message-ID: <CA+55aFyzsMg6rVay64SAAekGj7Eu+wcWkZ+TdycT7q=GBmuu+A@mail.gmail.com>
Subject: Re: 3.1-rc5 dont boot
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 8:06 PM, werner <w.landgraf@ru.ru> wrote:
>
> I recompiled 3.1-rc1 for see the problem again, with loglevel=8
> I get the following messages:

This looks like the CONFIG_X86_INVD_BUG problem. But that is fixed by
commit b4ca46e4e82a ("x86-32: Fix boot with CONFIG_X86_INVD_BUG"), so
it doesn't explain -rc5 not booting.

So try to apply that commit ("git cherry-pick b4ca46e4e82a") and try
booting -rc1 again.

                            Linus
