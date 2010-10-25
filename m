Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0JYIeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:34:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4491 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0JYIeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:34:17 -0400
Date: Mon, 25 Oct 2010 10:34:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: error importing i2c quilt series
Message-ID: <20101025103404.73c24f45@endymion.delvare>
In-Reply-To: <20101025105900.83472a69.sfr@canb.auug.org.au>
References: <20101025105900.83472a69.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 25 Oct 2010 10:59:00 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> Trying to import today's i2c quilt series gave me these errors:
> 
> i2c-i801-add-intel-patsburg-device-id.patch
> error: patch failed: include/linux/pci_ids.h:2444
> error: include/linux/pci_ids.h: patch does not apply
> Context reduced to (1/1) to apply fragment at 101
> Context reduced to (1/1) to apply fragment at 45
> error: patch failed: drivers/i2c/busses/i2c-i801.c:592
> error: drivers/i2c/busses/i2c-i801.c: patch does not apply
> 
> I will use the i2c tree from next-20101022 for today.

This patch depends on a patch adding/updating PCI IDs which I thought
was in Jesse Barnes' pci tree which you also pull in linux-next.
Apparently my assumption was wrong.

Jesse, where's this patch?
  https://patchwork.kernel.org/patch/230361/
I certainly hope it's scheduled for merge soon!

Meanwhile I've removed the other patch from my i2c-next tree, it will
be back only when I'm certain it applied fine.

Thanks,
-- 
Jean Delvare
