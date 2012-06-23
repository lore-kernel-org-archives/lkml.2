Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2FWREG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 13:04:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42884 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2FWRDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 13:03:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120623105118.GR4037@opensource.wolfsonmicro.com>
References: <20120622232149.GA29819@www.outflux.net>
	<20120623105118.GR4037@opensource.wolfsonmicro.com>
Date: Sat, 23 Jun 2012 10:03:17 -0700
X-Google-Sender-Auth: 6EB_9qFvcquQfNokc03nC_6NKKg
Message-ID: <CAGXu5jLGNQj4LqrePpAV_kVBGFX9AxrFs11Hjzg6qk5K=QFxyw@mail.gmail.com>
Subject: Re: [PATCH] sound: fix MODULE_LICENSE typos
From: Kees Cook <keescook@chromium.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ola Lilja <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org,
        Joshua Kroll <joshkroll@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 3:51 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jun 22, 2012 at 04:21:49PM -0700, Kees Cook wrote:
>> include/linux/license.h does not recognize "GPLv2", so adjust these
>> declarations to add the needed space before the version.
>
> This patch isn't against current -next which doesn't have this issue,
> I've no idea what you generated against as a version with this has never
> even been in -next.  Please do also use subject lines that resemble
> those used in the rest of the subsystem, having to hand edit commit logs
> is tedious.
>
> It seems more sensible to fix license.h, GPLv2 is a pretty common way of
> writing the license name in the wider community.

Ah-ha, yes, I see there's already fixed in -next. Thanks!

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=85f243912b99b053ce0624c30609f5d8fd4445d2

-Kees

-- 
Kees Cook
Chrome OS Security
