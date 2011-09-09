Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1IIOj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:39:26 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:45376 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab1IIOjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:39:25 -0400
Date: Fri, 9 Sep 2011 11:49:52 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jesper Juhl <jj@chaosbits.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Kosina <jkosina@suse.cz>, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        uclinux-dist-devel@blackfin.uclinux.org, linux-cris-kernel@axis.com
Subject: Re: [PATCH 54/62] TTY: irq: Remove IRQF_DISABLED
Message-ID: <20110909094952.GI11405@distanz.ch>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-55-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-55-git-send-email-yong.zhang0@gmail.com>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-07 at 10:10:51 +0200, Yong Zhang <yong.zhang0@gmail.com> wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

For altera_jtaguart and altera_uart:

Acked-by: Tobias Klauser <tklauser@distanz.ch>
