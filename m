Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1KNUuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:50:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab1KNUui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <abb1d8b542872ef3bfd695e85d3b8a0fd70645b9.1320917558.git.joe@perches.com>
References: <cover.1320917551.git.joe@perches.com>
	<abb1d8b542872ef3bfd695e85d3b8a0fd70645b9.1320917558.git.joe@perches.com>
Date: Mon, 14 Nov 2011 21:50:37 +0100
X-Google-Sender-Auth: zDYCvielUc_pbw51R8J7cXqCAKI
Message-ID: <CAMuHMdW+KORv6K6jMxTVOM=EeVQ6JTHHe9cOVfKZ39x4NcgvfQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] treewide: Convert uses of ATTRIB_NORETURN to __noreturn
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linux-am33-list@redhat.com,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:41, Joe Perches <joe@perches.com> wrote:
> Use the more commonly used __noreturn instead of ATTRIB_NORETURN.
>
> Signed-off-by: Joe Perches <joe@perches.com>

For the m68k parts:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
