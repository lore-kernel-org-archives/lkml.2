Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab2K0JyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:54:04 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49427 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758351Ab2K0JyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:54:03 -0500
Date: Tue, 27 Nov 2012 10:53:57 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] tty: don't dead while flushing workqueue
Message-ID: <20121127095357.GA3536@breakpoint.cc>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
 <20121121140426.1860d093@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121140426.1860d093@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 02:04:26PM +0000, Alan Cox wrote:
> > I don't see any problems in my testcase.
> 
> This looks fine to me as by the time we call tty_ldisc_release we have
> already set TTY_CLOSING on both sides.

Greg, can you push this into v3.7? This regression has been introduced in
v3.7-rc1. If you don't consider it as this important since I'm only one
complaining, could you please add a stable tag once you apply it unless you
want me resend it with a stable tag.

> Alan

Sebastian
