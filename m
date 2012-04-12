Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2DLEy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:54:59 -0400
Received: from void.printf.net ([89.145.121.20]:38632 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2DLEyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:54:52 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mmc tree
References: <20120412140206.704731281bf2ee7d93d582bf@canb.auug.org.au>
Date: Thu, 12 Apr 2012 00:54:34 -0400
In-Reply-To: <20120412140206.704731281bf2ee7d93d582bf@canb.auug.org.au>
	(Stephen Rothwell's message of "Thu, 12 Apr 2012 14:02:06 +1000")
Message-ID: <87pqbdr1md.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 12 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/mmc/host/Kconfig between commit a334b9550294 ("mmc: remove imxmmc
> driver") from the mmc tree and commits a21a92c0c787 ("mmc: Kconfig: remove
> choice between at91_mci and atmel-mci") and 62080f06de6b ("mmc:
> atmel-mci: remove the need for CONFIG_MMC_ATMELMCI_DMA") from the arm-soc
> tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, Stephen.

Nicolas and Arnd, these MMC Kconfig patches weren't sent to me or
linux-mmc@ for review, so I haven't seen them before.  They look
fine, but I'd like to be in the loop directly to avoid surprises.

Do these MMC patches have any dependency on other work?  It doesn't
look like it.  If that's so, I'd rather carry them in the MMC tree
to save Stephen and Linus from dealing with the merge conflict.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
