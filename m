Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2KZXp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:45:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:39179 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab2KZXpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:45:55 -0500
Date: Mon, 26 Nov 2012 15:45:53 -0800
From: Greg KH <greg@kroah.com>
To: chao bi <chao.bi@intel.com>
Cc: Alan Cox <alan@linux.intel.com>, richardx.r.gorby@intel.com,
        jun.d.chen@intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial:ifx6x60:Delete SPI timer when shut down port
Message-ID: <20121126234553.GA14899@kroah.com>
References: <1353634413.22077.15.camel@bichao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353634413.22077.15.camel@bichao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 09:33:33AM +0800, chao bi wrote:
> 
> When shut down SPI port, it's possible that MRDY has been asserted and a SPI
> timer was activated waiting for SRDY assert, in the case, it needs to delete
> this timer.

This doesn't apply without fuzz, so I don't know what tree you are
working against here.

Please redo it against the latest version of the tty-next tree.

greg k-h
