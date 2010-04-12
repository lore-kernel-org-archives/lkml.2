Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0DLTKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:10:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35343 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0DLTKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:10:32 -0400
Date: Mon, 12 Apr 2010 20:10:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Victor <avictor.za@gmail.com>
Cc: Anders Larsen <al@alarsen.net>, linux-arm-kernel@lists.infradead.org,
       Julien Langer <julien.langer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AT91 slow-clock suspend: don't wait when turning
	PLLs off
Message-ID: <20100412191006.GJ3048@n2100.arm.linux.org.uk>
References: <20100303213329.GA500@alarsen.net> <w2ocd73a99e1004061427t322f8d4cmecd708ad16580f00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w2ocd73a99e1004061427t322f8d4cmecd708ad16580f00@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 11:27:55PM +0200, Andrew Victor wrote:
> hi Anders,
> 
> > From: Julien Langer <julien.langer@gmail.com>
> >
> > AT91: when turning off the PLLs during suspend, don't wait for the lock flag
> > to be set. Previously the code would always run into the loop limitation
> > of 1000 iterations because the flag is never set when turning the PLLs off.
> >
> > Signed-off-by: Julien Langer <julien.langer@gmail.com>
> > Signed-off-by: Anders Larsen <al@alarsen.net>
> > Cc: Andrew Victor <avictor.za@gmail.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> During suspend we set the MULA and MULB bits to 0 to disable the
> PLL's.  When disabled, the PLLs will never "lock".
> 
>    Acked-by: Andrew Victor <linux@maxim.org.za>
> 
> 
> Russell:  This is patch 5975/1 in the patch-system.

Thanks; I see your ack has been added to that patch.  Should I assume that
this is for -rc rather than -devel?
