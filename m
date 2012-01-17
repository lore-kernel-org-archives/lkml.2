Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2AQPxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:53:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab2AQPxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:53:23 -0500
Date: Tue, 17 Jan 2012 07:41:23 -0800
From: Greg KH <gregkh@suse.de>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: linux-serial@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amba-pl011: do not disable RTS during shutdown
Message-ID: <20120117154123.GA13296@suse.de>
References: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 03:59:49PM +0530, Shreshtha Kumar SAHU wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> In present driver, shutdown clears RTS in CR register. But the
> documentation "Documentation/serial/driver" suggests not to
> disable RTS in shutdown(). Also RTS is preserved between shutdown
> and startup calls, i.e. it is restored in startup if it was enabled
> during shutdown. So that if autorts is set and RTS is set using
> pl011_set_mctrl then it should continue even after shutdown->startup
> sequence. And hence during set_termios it will enable RTS only if RTS
> bit is set in UARTx_CR register. For throttling/unthrottling user
> should call pl011_set_mctrl.
> 
> Change-Id: I743f33fb10e7e655657cd5dae1ec585e914a65bc

What is this field, and why would we want it in the kernel.org
changelogs?

Please remove it.  Same goes for your other patch.

greg k-h
