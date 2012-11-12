Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2KLQnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:43:22 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59355 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab2KLQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <1352734564.2262.7.camel@sauron.fi.intel.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-75-git-send-email-keescook@chromium.org>
	<1352734564.2262.7.camel@sauron.fi.intel.com>
Date: Mon, 12 Nov 2012 08:43:19 -0800
X-Google-Sender-Auth: C-tV27AJmYg_Qmx6Bz8w4xHyoNo
Message-ID: <CAGXu5jJ2XMB+hhzH0MFY3=tkF+iFY8srbKbvy6RMxdrnb0-FYA@mail.gmail.com>
Subject: Re: [PATCH 074/193] drivers/mtd/devices: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: dedekind1@gmail.com
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 7:36 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Tue, 2012-10-23 at 13:02 -0700, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>>
>> CC: David Woodhouse <dwmw2@infradead.org>
>> CC: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
>> CC: Robert Jarzmik <robert.jarzmik@free.fr>
>> CC: Fabio Estevam <fabio.estevam@freescale.com>
>> CC: Richard Weinberger <richard@nod.at>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Will this stuff be merged in one go or you want it to go via subsystems?

Stephen Rothwell asked that subsystem maintainers carry the patches to
make it easier to do merges, but in the cases where that's not
possible or a maintainer would like me to carry it, I've been putting
them into my linux-next tree. It's up to you; if you take it into your
tree, I'll drop it from mine. Just let me know either way. :)

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
