Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0LMRMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:12:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758438Ab0LMRMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:12:14 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19fD/AjUVRfuzUxF/jSQwtrfhjxFKlHFdk2716eco
	gT1om+9A+UxAmD
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH v2] avr32: Fix build failure conflicting types for 'sys_execve'
Date: Mon, 13 Dec 2010 18:12:01 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
References: <20101209182132.GB24175@kroah.com> <201012122037.59016.PeterHuewe@gmx.de> <1292227973.18008.53.camel@hcegtvedt>
In-Reply-To: <1292227973.18008.53.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012131812.03487.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 13 Dezember 2010, 09:12:53 schrieb Hans-Christian Egtvedt:
> > (but it still failed for quite a while longer due to other issues ;)
> What other issues?

There's a linker error at the end:

  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
lib/lib.a(vsprintf.o): In function `resource_string':
vsprintf.c:(.text+0x149e): relocation truncated to fit: R_AVR32_9UW_PCREL 
against `.text'+16a8
vsprintf.c:(.text+0x14ae): relocation truncated to fit: R_AVR32_9UW_PCREL 
against `.text'+16ac

which seems to exist since May 26th in Linus' tree.
See 
http://kisskb.ellerman.id.au/kisskb/buildresult/2631302/
http://kisskb.ellerman.id.au/kisskb/target/664/
for more details.

Unfortunately I wasn't able to locate the offending commit using git bisect :/



Reported-by: Peter Huewe <peterhuewe@gmx.de>

> > (a reported by on the patch would have been nice ;)
> Of course, I'll rebase and add you're name to it. Does the same go for
> David Howells?
Great, thanks. - although I'm not sure wether an ack, reported-by or signed-
off by fits best ;)
I did get an ack from him:
> Acked-by: David Howells <dhowells@redhat.com>


Thanks,
Peter




