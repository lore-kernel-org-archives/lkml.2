Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2CGOQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:16:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45254 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab2CGOQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:16:01 -0500
MIME-Version: 1.0
In-Reply-To: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 7 Mar 2012 09:15:59 -0500
Message-ID: <CA+5PVA7PCow=Z7TpPtQYp3ye6uKFSp3XsdH75Pe9BRu9Vyy21g@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kbuild: centralize MKIMAGE and cmd_uimage definitions
From: Josh Boyer <jwboyer@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 7:30 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> All ARCHs have the same definition of MKIMAGE. Move it to Makefile.lib
> to avoid duplication.
>
> All ARCHs have similar definitions of cmd_uimage. Place a sufficiently
> parameterized version in Makefile.lib to avoid duplication.
>
> The centralized cmd_uimage definition will allow the future introduction
> of a centralized Kconfig option to make cmd_uimage use -T kernel_noload
> rather than -T kernel.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> NOTE: I have not tested this patch in any way at all for architectures
> other than ARM.
>
>  arch/arm/boot/Makefile          |   23 +++++++++--------------
>  arch/avr32/boot/images/Makefile |    9 +++------
>  arch/blackfin/boot/Makefile     |   19 ++++++++-----------
>  arch/microblaze/boot/Makefile   |   10 +++-------
>  arch/sh/boot/Makefile           |    8 ++------
>  arch/sparc/boot/Makefile        |    9 +++------
>  arch/unicore32/boot/Makefile    |   12 ++----------
>  scripts/Makefile.lib            |   24 ++++++++++++++++++++++++
>  8 files changed, 54 insertions(+), 60 deletions(-)

Is there a reason you skipped powerpc?

josh
