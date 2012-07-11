Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2GKRvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:51:15 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:53423 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2GKRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:51:13 -0400
Date: Wed, 11 Jul 2012 11:51:12 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>
Subject: Re: [PATCH 1/2] gpio/omap: move bank->dbck initialization to
 omap_gpio_mod_init()
In-Reply-To: <1341997995-14020-2-git-send-email-tarun.kanti@ti.com>
Message-ID: <alpine.DEB.2.00.1207111148400.25585@utopia.booyaka.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com> <1341997995-14020-2-git-send-email-tarun.kanti@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Tarun Kanti DebBarma wrote:

> Since the bank->dbck initialization in a one time operation there
> is no need to keep this within gpio_debounce(). Therefore, moving
> clk_get(bank->dbck) to omap_gpio_mod_init(). Since the value of
> bank->dbck would be NULL at the beginning, this check has been
> removed.
> 
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Reported-by: Paul Walmsley <paul@pwsan.com>
> Reviewed-by: Jon Hunter <jon-hunter@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson, Benoit <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> ---
>  drivers/gpio/gpio-omap.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)

Reviewed-by: Paul Walmsley <paul@pwsan.com>

These drivers are maintained by Grant Likely and Linus Walleij:

GPIO SUBSYSTEM
M:      Grant Likely <grant.likely@secretlab.ca>
M:      Linus Walleij <linus.walleij@stericsson.com>
S:      Maintained
T:      git git://git.secretlab.ca/git/linux-2.6.git
F:      Documentation/gpio.txt
F:      drivers/gpio/
F:      include/linux/gpio*

So you'll want to cc them.  They are probably also who should merge these.


- Paul
