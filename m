Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1EJIjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:39:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44404 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1EJIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:38:37 -0400
Subject: Re: linux-next: build failure after merge of the voltage tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20110510124434.b30a7631.sfr@canb.auug.org.au>
References: <20110510124434.b30a7631.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 09:38:32 +0100
Message-ID: <1305016712.3206.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 12:44 +1000, Stephen Rothwell wrote:
> Hi Liam,
> 
> After merging the voltage tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "tps65910_gpio_init" [drivers/mfd/tps65910.ko] undefined!
> ERROR: "tps65910_irq_init" [drivers/mfd/tps65910.ko] undefined!
> ERROR: "irq_modify_status" [drivers/mfd/tps65910-irq.ko] undefined!
> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/tps65910-irq.ko] undefined!
> ERROR: "handle_edge_irq" [drivers/mfd/tps65910-irq.ko] undefined!
> 
> I have used the voltage tree from next-20110509 for today.

Jorge, could you send a fix for this today.

Thanks

Liam

