Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2ISO6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:58:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2ISO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:58:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to drivers/bus/
Date: Wed, 19 Sep 2012 14:58:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com> <20120917215128.GF11762@atomide.com>
In-Reply-To: <20120917215128.GF11762@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191458.00531.arnd@arndb.de>
X-Provags-ID: V02:K0:N45CcEHt4kvn2GyUPnK6cd8r2hdYsAgMO8m7ykFWtbG
 8zzYi53BUcANnKATxTR8Y6mx/ff/9s49q4s8F5aBY4fG7fcdW4
 0Q0zppsmWb11jhJJ7L6DZKrqn2GOgNs3qJZnULQx7Yyjh5OptY
 DqqOQ9qOngZmGzY1cI4Kkgb+xsw0fF8sCcbSQmJDh+TnxFu+J1
 6N7hDuvwe2tEs4PYkjFbrnQtG4gfimLQXu6jHHJzZ2UJ5x9DQM
 Ebgsdt04MRhzXAa7M0V+qF/k8O06liAcfBKae0pQI8DMMP9mnT
 eAsgB5VJ0Pnh60vMBHQ444xnLMc1PaMg/3Jx4W0rAw3+Vl0jiU
 audBgSBtNrptSmCqOKPY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Tony Lindgren wrote:
> * Santosh Shilimkar <santosh.shilimkar@ti.com> [120914 02:21]:
> > OMAP interconnect drivers are used for the interconnect error handling.
> > Since they are bus driver, lets move it to newly created drivers/bus.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > ---
> > Patch just moves OMAP interconnect drivers as is to the newly created
> > driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
> > tree and test on all OMAP boards.
> 
> Great, looks like this should not conflict with other
> omap patches queued, so Arnd should probably take this into
> the bus branch:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Ok, added to the branch. In the future please Cc both Olof and me when submitting
patches for inclusion.

Olof: I figured it would be easier if I just add this one than relaying it to
you.

	Arnd
