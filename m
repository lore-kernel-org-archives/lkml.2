Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2CSJEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:04:48 -0400
Received: from mx6.pku.edu.cn ([162.105.129.60]:43956 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754326Ab2CSJEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:04:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -311.408
Message-ID: <4F66F6DF.8010609@pku.edu.cn>
Date: Mon, 19 Mar 2012 17:05:35 +0800
From: Guan Xueao <gxt@pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Kbuild: centralize MKIMAGE and cmd_uimage definitions
References: <1331931835-12346-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1331931835-12346-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 05:03 AM, Stephen Warren wrote:
> All ARCHs have the same definition of MKIMAGE. Move it to Makefile.lib
> to avoid duplication.
>
> All ARCHs have similar definitions of cmd_uimage. Place a sufficiently
> parameterized version in Makefile.lib to avoid duplication.
>
> Signed-off-by: Stephen Warren<swarren@wwwdotorg.org>
> ---
> v2:
> * Fix blackfin's UIMAGE_LOADADDR in the ROMKERNEL case.
> * Fix missing ) on a variable reference in avr32 and sparc.
> * Only set those UIMAGE_* variables that the arch-specific Makefile hasn't
>    already set.
> * The patch series is now just this single patch which removes duplication;
>    I've dropped the Kconfig feature to allow use of -T kernel_noload for
>    now, since it looks like U-Boot is gaining direct zImage support.
>
>
Tested on unicore32.

Tested-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

