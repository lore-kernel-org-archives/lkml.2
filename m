Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0DZV6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:58:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46328 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752675Ab0DZV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:58:54 -0400
Date: Mon, 26 Apr 2010 23:03:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, npelly@google.com,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH] drivers:staging: sources for ST core
Message-ID: <20100426230352.1564ef0f@lxorguk.ukuu.org.uk>
In-Reply-To: <1270750619-19174-3-git-send-email-pavan_savoy@ti.com>
References: <1270750619-19174-1-git-send-email-pavan_savoy@ti.com>
	<1270750619-19174-2-git-send-email-pavan_savoy@ti.com>
	<1270750619-19174-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +/* function pointer pointing to either,
> + * st_kim_recv during registration to receive fw download responses
> + * st_int_recv after registration to receive proto stack responses
> + */
> +void (*st_recv) (void*, const unsigned char*, long);

You still need a context of some kind as I said before to avoid thse
globals and single device limits.

And all the other issues - no explanation of the locking etc don't seem
to have been touched either.

I don't really see how I am supposed to review this stuff when the
locking and flow control assumptions are completely opaque

Alan
