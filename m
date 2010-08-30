Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0H3M2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:28:14 -0400
Received: from relay.atmel.no ([80.232.32.139]:52450 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab0H3M2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:28:13 -0400
Date: Mon, 30 Aug 2010 14:27:27 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 02/10] ioctl: Use asm-generic/ioctls.h on avr32 (enables
 termiox)
Message-ID: <20100830142727.09830279@hskinnemoen-d830>
In-Reply-To: <20100820211538.179970218@suse.com>
References: <20100820211401.651509182@suse.com>
	<20100820211538.179970218@suse.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> wrote:
> This patch converts avr32 to use asm-generic/ioctls.h instead of its
> own version.
> 
> The differences between the arch-specific version and the generic
> version are as follows:
> 
> - The generic version adds support for termiox
> 
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Makes sense to me. Perhaps not so good that it adds extra code for
termiox, but then again, I guess it might be useful some day, as the
USART hardware has a lot of extra modes that the current atmel_serial
driver doesn't support.

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
