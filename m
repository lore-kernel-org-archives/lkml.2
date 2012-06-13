Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2FMMt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:49:26 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53785 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FMMtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVM3zn_OUAtGTV_O0d3yFWBM5b_6ORHxaMLVE27Cf_XrQ@mail.gmail.com>
References: <CAMuHMdW9D4FZSUibcd+qrtM+is75FyJXj+RxK+sb33XEjczdyg@mail.gmail.com>
	<CAMuHMdVM3zn_OUAtGTV_O0d3yFWBM5b_6ORHxaMLVE27Cf_XrQ@mail.gmail.com>
Date: Wed, 13 Jun 2012 14:49:21 +0200
X-Google-Sender-Auth: KBMI2DV16JlTDwCmKmYdTt-Fcsc
Message-ID: <CAMuHMdUw6fCcNmUmpzLfYkfKz1W=9E2o24VUiheLDGJdU58qAg@mail.gmail.com>
Subject: Re: asm/kvm_para.h from asm-generic (was: Re: linux-next: triage for
 April 19, 2012)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>, kvm@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 2:46 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> "make headers_check" is also broken on m32r since Avi's fix, as m32r
> doesn't even
> have <asm/kvm_param.h>:

BTW, you don't need to install any cross-compilers for headers_check, just do

make ARCH=xxx headers_check

if you want to give it a try...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
