Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1HZKrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:47:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1HZKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <268bd0822736c924e45d966aa0ca3d60637ccc2b.1314291910.git.jbaron@redhat.com>
References: <cover.1314291909.git.jbaron@redhat.com> <268bd0822736c924e45d966aa0ca3d60637ccc2b.1314291910.git.jbaron@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 26 Aug 2011 12:46:51 +0200
X-Google-Sender-Auth: U-jmhmtSYrFyMjc2lKwGzMf0SKQ
Message-ID: <CAO+b5-qfVRjQWNbdzK-GdU+GJT45LuifNSAYvn8bzpw+d=8O4A@mail.gmail.com>
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7QAlRM0013865

On Thu, Aug 25, 2011 at 7:34 PM, Jason Baron <jbaron@redhat.com> wrote:
>
> +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)              \
> +       static struct _ddebug __used __aligned(8)               \
> +       __attribute__((section("__verbose"))) name = {          \
> +               .modname = KBUILD_MODNAME,                      \
> +               .function = __func__,                           \
> +               .filename = __FILE__,                           \
> +               .format = fmt,                                  \
> +               .lineno = __LINE__,                             \
> +               .flags =  _DPRINTK_FLAGS_DEFAULT,               \
> +               .enabled = false,                               \
> +       }

A minor remark: macro arguments are usually surrounded by parentheses
in a macro definition. That's not the case for "fmt" in the above.

Bart.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
