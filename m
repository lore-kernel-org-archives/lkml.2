Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1LJJt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 04:49:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47100 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1LJJty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 04:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <4EE2191E.8070107@linux.intel.com>
References: <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org>
	<28442.1323269262@redhat.com>
	<2409.1323422253@redhat.com>
	<4EE2191E.8070107@linux.intel.com>
Date: Sat, 10 Dec 2011 10:49:52 +0100
X-Google-Sender-Auth: H2HtRn4x-yx9bi3HRrRoIxgnmk8
Message-ID: <CAMuHMdXn1xcFpVFUxukAPpM7x6Z5hfyS0PvUXSQnNao5q26gig@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto keys and module signing
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 15:20, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> I wonder what the best way to deal with that is...  I guess make
>> allyesconfig and make allmodconfig are going to break otherwise.
>
> the best way to deal is to have KBUILD generate a key on demand ;-)

Or provide a default key with the kernel, cfr. all the other "*.shipped" files?
No entropy source needed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
