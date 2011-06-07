Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab1FGTed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:34:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab1FGTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:34:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Tue, 7 Jun 2011 21:34:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linuxppc-dev@lists.ozlabs.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        kumar.gala@freescale.com, linux-kernel@vger.kernel.org,
        akpm@kernel.org, Deepak Saxena <dsaxena@linaro.org>,
        linux-console@vger.kernel.org, greg@kroah.com
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106072116.21469.arnd@arndb.de> <4DEE7A12.80302@freescale.com>
In-Reply-To: <4DEE7A12.80302@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106072134.24721.arnd@arndb.de>
X-Provags-ID: V02:K0:WH1inCuMDelYoOHELZJRqrnFyBqbBADzwcoR2Hauiv6
 lCJAQ8nU9PSd53j5tmi1tJHfTHBsJaWDtNo/btDlACEEfotmaI
 EMmuEnnpUHhNLSjz1kA29uXnHRXpL8vySE+EVx03GqmwTc5zT1
 iJX1Q/NdkzTCodX9lcNDF/rHswMwN+ts5/t411Vp8fWQ5Z2zLw
 2sDgzdVoxRJidkEE6ahBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 June 2011 21:20:50 Timur Tabi wrote:
> Arnd Bergmann wrote:
> > For the spi flash driver that goes through the hypervisor abstraction,
> > I think drivers/virt/tile would be better than driver/platform/tile,
> > but we should really have a new "abstract flash character driver" subsystem
> > for that.
> 
> Why should it matter that the SPI flash driver goes through the hypervisor
> abstration?  One of the patches in this patchset is a TTY driver that goes
> through the Freescale hypervisor.  I put the drivers in drivers/tty.

The driver in question is for a hypervisor that abstracts the flash memory
using a read/write interface. There is no way you can represent that as
a SPI host driver.

	Arnd
