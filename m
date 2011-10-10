Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1JJQHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:07:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1JJQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:07:38 -0400
Date: Mon, 10 Oct 2011 07:14:02 -0700
From: Greg KH <gregkh@suse.de>
To: Harro Haan <hrhaan@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ehci alignment error
Message-ID: <20111010141402.GA21856@suse.de>
References: <20111010124154.464239811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010124154.464239811@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 02:38:27PM +0200, Harro Haan wrote:
> The Kirkwood gave an unaligned memory access error on
> line 742 of drivers/usb/host/echi-hcd.c:
> "ehci->last_periodic_enable = ktime_get_real();"

What is "The Kirkwood"?  What size processor is this?

