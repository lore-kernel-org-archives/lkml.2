Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0LKUHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:07:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56045
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab0LKUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:07:10 -0500
Date: Sat, 11 Dec 2010 12:07:38 -0800 (PST)
Message-Id: <20101211.120738.59690708.davem@davemloft.net>
To: plyatov@gmail.com
Cc: sshtylyov@mvista.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, geomatsi@gmail.com,
        nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH] ide: at91_ide.c bugfix for high master clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292097745-9680-1-git-send-email-plyatov@gmail.com>
References: <1292097745-9680-1-git-send-email-plyatov@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor Plyatov <plyatov@gmail.com>
Date: Sat, 11 Dec 2010 23:02:25 +0300

> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and at91_ide
> driver does not detect ATA device.
> This patch must be applied on top of my patch for pata_at91 where the
> same bug fixed.
> 
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>

Please submit this as two patches, since different people maintain
the IDE vs. ATA layers.

In fact the dev_warn() change is the only change you made to the
ATA driver and that has nothing to do with the bug fix you are
making here.  So it would belong as a seperate patch submission
anyways.

Thanks.

