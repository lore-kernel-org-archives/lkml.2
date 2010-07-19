Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab0GSAQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 20:16:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:60922 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab0GSAQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 20:16:00 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>
In-Reply-To: <20100716171920.51ce1b88.sfr@canb.auug.org.au>
References: <20100716171920.51ce1b88.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 10:15:41 +1000
Message-ID: <1279498541.10390.1773.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 17:19 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allmodconfig) failed like this:
> 
> ERROR: "of_i8042_kbd_irq" [drivers/input/serio/i8042.ko] undefined!
> ERROR: "of_i8042_aux_irq" [drivers/input/serio/i8042.ko] undefined!
> 
> Presumably missing EXPORT_SYMBOLs ..

Thanks. I'll fix that up.

Cheers,
Ben.



