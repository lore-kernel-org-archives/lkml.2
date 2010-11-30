Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab0K3VRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:17:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0K3VRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:17:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
Date: Tue, 30 Nov 2010 22:17:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org> <alpine.LFD.2.00.1011301455400.9313@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1011301455400.9313@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011302217.19596.arnd@arndb.de>
X-Provags-ID: V02:K0:lqwCgjpLksGUNvFhHX/sMsDDC0xLSAeOoamhFgAl46q
 cZljQ6spaus2Smbxft9kNNbWiPzrQSs7lObAH4JNxX2+Ac3vAY
 SZqRzpSvr8v51IdVHnB8HuXv4BCqroVUvcm3ZLucI75CcMRszG
 +c4ranFLuXi65F47BHpG2whKyYxHNxobJsii8jwKtzSaMBOIVl
 BYyv+HPp6tSs/0RbvaEGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 November 2010, Nicolas Pitre wrote:
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nicolas Pitre <nico@fluxnic.net>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> 
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> This doesn't support both ARMv6 and ARMv7 at run time, but this can 
> trivially be added later when needed.

I was about to make a similar comment when I saw yours ;-)
