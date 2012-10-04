Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2JDRMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:12:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49518 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2JDRMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <18137.1349203013@warthog.procyon.org.uk>
References: <18137.1349203013@warthog.procyon.org.uk>
Date: Thu, 4 Oct 2012 19:12:47 +0200
X-Google-Sender-Auth: fhUFlCkaeTVbAzxgdUnNn2pX-Hk
Message-ID: <CAMuHMdUx6he0MdL5etO6pDrMgd=JZWsf1TZj5WevjSpFANCWRA@mail.gmail.com>
Subject: Re: [GIT PULL] User API Disintegrate: Preparatory patches
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, arnd@arndb.de, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
        fengguang.wu@intel.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 8:36 PM, David Howells <dhowells@redhat.com> wrote:
>  include/linux/libfdt.h                           |  4 +-

So what happened here?

 -#include "../../scripts/dtc/libfdt/fdt.h"
-#include "../../scripts/dtc/libfdt/libfdt.h"
+#include <>
+#include <>

Woops...

http://kisskb.ellerman.id.au/kisskb/buildresult/7312681/
include/linux/libfdt.h:5:10: error: empty filename in #include
include/linux/libfdt.h:6:10: error: empty filename in #include

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
