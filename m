Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2JPOFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:05:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53365 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2JPOFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:05:36 -0400
Date: Tue, 16 Oct 2012 15:05:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Daniel Mack <zonque@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] signals pile 3
Message-ID: <20121016140525.GG21164@n2100.arm.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk> <507ADBBB.9090209@gmail.com> <20121014202431.GL21164@n2100.arm.linux.org.uk> <20121014222449.GN21164@n2100.arm.linux.org.uk> <507B3F2C.1090500@gmail.com> <20121014231649.GO21164@n2100.arm.linux.org.uk> <20121016140414.GS639@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121016140414.GS639@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 04:04:14PM +0200, Uwe Kleine-König wrote:
> I used:
>  	movne	r0, r4
> -	movne	lr, pc
> -	movne	pc, r5
> +	blxne	r5
>  	get_thread_info tsk
> 
> but I assume Russell's patch is better. (Probably because blx doesn't
> exist everywhere?!)

Correct.

> So if it's not too late yet:
> 
> Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

It is, because it's already in Linus' tree.
