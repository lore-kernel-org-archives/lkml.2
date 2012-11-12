Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KLXwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:52:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59716 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2KLXwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:52:08 -0500
Date: Mon, 12 Nov 2012 15:51:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Peter Hurley <peter@hurleysoftware.com>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
Message-ID: <20121112235154.GA14017@kroah.com>
References: <1350565015.23730.4.camel@thor>
 <cover.1351817601.git.peter@hurleysoftware.com>
 <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
 <20121113003338.6aafd7c8@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113003338.6aafd7c8@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 12:33:38AM +0100, Stefan Richter wrote:
> On Nov 02 Peter Hurley wrote:
> > This patch provides the kernel driver for high-speed TTY
> > communication over the IEEE 1394 bus.
> > 
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> 
> Hi Greg,
> 
> you asked for an Ack.  Here it is:  I am OK with this getting added to the
> staging tree.

Thanks, I'll queue it up later this week when I return from my travels.

greg k-h
