Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965Ab2JXO25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:28:57 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43646 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934939Ab2JXO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:28:55 -0400
Date: Wed, 24 Oct 2012 16:28:52 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: lockdep says circular locking since "tty: localise the lock"
Message-ID: <20121024142852.GE4368@breakpoint.cc>
References: <20121017192035.GA31303@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017192035.GA31303@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:20:35PM +0200, Sebastian Andrzej Siewior wrote:
> With dummy_hcd and g_nokia (that is CONFIG_USB_GADGET=m,
> CONFIG_USB_DUMMY_HCD=m, CONFIG_USB_G_NOKIA=m) I see a lockdep complaing
> about a "circular locking dependency" after executing

ping? Or is it an obvious false positive?

Sebastian
