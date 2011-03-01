Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1CAFsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:48:24 -0500
Received: from kroah.org ([198.145.64.141]:56197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1CAFsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:48:22 -0500
Date: Mon, 28 Feb 2011 19:18:23 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel@pengutronix.de, Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] tty/vt: add some KERN_CONT markers to continuation
 lines
Message-ID: <20110301031823.GA14927@kroah.com>
References: <20101124085645.GW4693@pengutronix.de>
 <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:57:50AM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/tty/vt/vt.c |   10 +++++-----

This doesn't apply on the linux-next tree, care to refresh it and
resend so I can apply it?

thanks,

greg k-h
