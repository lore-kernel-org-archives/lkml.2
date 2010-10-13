Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0JMG3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:29:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:59092 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab0JMG3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:29:43 -0400
Date: Tue, 12 Oct 2010 23:26:05 -0700
From: Greg KH <gregkh@suse.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com,
        kyungmin.park@samsung.com, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted
	condition.
Message-ID: <20101013062605.GB4393@suse.de>
References: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 02:58:06PM +0900, MyungJoo Ham wrote:
> When console_suspend_enabled == 0, console_stop() was not called at
> suspend; thus, it does not need to call console_start() when resume.
> Besides, calling console_start() without calling console_stop() before
> had been incurring kernel hang with console_suspend_enabled == 0 in a
> machine with drivers/serial/samsung.c and s5pc210.

Is this a regression?  If so, from what working kernel?  Or has this
always been this way?

thanks,

greg k-h
