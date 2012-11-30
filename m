Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2K3RMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:12:00 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34513 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758543Ab2K3RJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:09:44 -0500
Date: Fri, 30 Nov 2012 18:09:38 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RESEND] tty: don't dead lock while flushing workqueue
Message-ID: <20121130170938.GA7323@breakpoint.cc>
References: <1353501542-14707-1-git-send-email-bigeasy@linutronix.de>
 <20121121140426.1860d093@pyramind.ukuu.org.uk>
 <20121127095357.GA3536@breakpoint.cc>
 <20121127172249.GB24592@kroah.com>
 <20121127180108.GA7376@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127180108.GA7376@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 07:01:08PM +0100, Sebastian Andrzej Siewior wrote:
> Since commit 89c8d91e31f2 ("tty: localise the lock") I see a dead lock
> in one of my dummy_hcd + g_nokia test cases. The first run one was usually
> okay, the second often resulted in a splat by lockdep and the third was
> usually a dead lock.

Ping. Can you feed this to your tty tree? :)

Sebastian
