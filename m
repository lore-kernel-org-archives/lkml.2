Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423133Ab2CPQU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:20:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:47044 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030239Ab2CPQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:20:57 -0400
Subject: Re: [PATCH v3 3/4] powerpc: Move GE PIC drivers
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1331572380-1064-4-git-send-email-martyn.welch@ge.com>
Date: Fri, 16 Mar 2012 11:13:55 -0500
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Transfer-Encoding: 7bit
Message-Id: <AF4135E9-8A86-4B17-8B6F-C7F9875FD8E7@kernel.crashing.org>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com> <1331572380-1064-4-git-send-email-martyn.welch@ge.com>
To: Martyn Welch <martyn.welch@ge.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2012, at 12:12 PM, Martyn Welch wrote:

> Move the GE PIC drivers to allow these to be used by non-86xx boards.
> 
> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
> 
> v2: Move GPIO and PIC drivers to sysdev/ge/ rather than platforms/.
> 
> v3: Now just PIC driver. GPIO driver going to drivers/gpio.
> 
> arch/powerpc/platforms/86xx/Kconfig                |    4 ----
> arch/powerpc/platforms/86xx/Makefile               |    1 -
> arch/powerpc/platforms/86xx/gef_ppc9a.c            |    2 +-
> arch/powerpc/platforms/86xx/gef_sbc310.c           |    2 +-
> arch/powerpc/platforms/86xx/gef_sbc610.c           |    2 +-
> arch/powerpc/sysdev/Kconfig                        |    4 ++++
> arch/powerpc/sysdev/Makefile                       |    2 ++
> arch/powerpc/sysdev/ge/Makefile                    |    1 +
> .../86xx/gef_pic.c => sysdev/ge/ge_pic.c}          |    2 +-
> .../86xx/gef_pic.h => sysdev/ge/ge_pic.h}          |    0
> 10 files changed, 11 insertions(+), 9 deletions(-)
> create mode 100644 arch/powerpc/sysdev/ge/Makefile
> rename arch/powerpc/{platforms/86xx/gef_pic.c => sysdev/ge/ge_pic.c} (99%)
> rename arch/powerpc/{platforms/86xx/gef_pic.h => sysdev/ge/ge_pic.h} (100%)

applied

- k
