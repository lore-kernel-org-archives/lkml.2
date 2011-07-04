Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1GDKO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:14:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52362 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab1GDKO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:14:28 -0400
Date: Mon, 4 Jul 2011 15:44:22 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SAMPLES: kprobe_example: make it more easy to use
Message-ID: <20110704101422.GA9308@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <CAM2zO=AEHu9+z8ebdyocwiyr2fThbAC6On4dbbVD00x6VJmXEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM2zO=AEHu9+z8ebdyocwiyr2fThbAC6On4dbbVD00x6VJmXEg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 03:27:39PM +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] SAMPLES: kprobe_example: make it more easy to use

...

> -	printk(KERN_INFO "post_handler: p->addr = 0x%p, flags = 0x%lx\n",
> -		p->addr, regs->flags);
> +	printk(KERN_INFO "post_handler: p->addr = 0x%p, ip = %lx,"
> +			" flags = 0x%lx\n",
> +		p->addr, regs->ip, regs->flags);

You are probably better off using the instruction_pointer(regs) helper
here and elsewhere..

Ananth
