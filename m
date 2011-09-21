Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1IUGUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:20:32 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:38085 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab1IUGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:20:31 -0400
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the arm
 tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20110921130222.58e566a354feef69f3064d04@canb.auug.org.au>
References: <20110921130222.58e566a354feef69f3064d04@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 09:13:30 +0300
Message-ID: <1316585610.1949.8.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 13:02 +1000, Stephen Rothwell wrote:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> drivers/video/omap/lcd_apollon.c drivers/video/omap/lcd_ldp.c
> drivers/video/omap/lcd_overo.c between commit 1bc857f700fb ("ARM: gpio:
> omap: convert drivers to use asm/gpio.h rather than mach/gpio.h") from
> the arm tree and commits db3136b14a2b ("OMAPFB: Remove unused lcd
> drivers") and 0cde58449424 ("OMAPDSS: Port the Apollon display driver to
> DSS2") from the omap_dss2 tree.
> 
> The latter two commist removed these files, so I did that.

Thanks, this is also correct.

 Tomi


