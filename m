Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0GDJLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 05:11:31 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39203 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab0GDJLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 05:11:30 -0400
Date: Sun, 4 Jul 2010 11:11:25 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Paul Sheer <p@2038bug.com>
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com,
       linux-usb-devel@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       johannes@erdfelt.com, mdharm-usb@one-eyed-alien.net, gregkh@suse.de,
       stern@rowland.harvard.edu, paulsheer@gmail.com
Subject: Re: USB mass storage fails to register on kernel 2.6.32
Message-ID: <20100704091125.GX17833@buzzloop.caiaq.de>
References: <1278230583.6443.27.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278230583.6443.27.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 10:03:03AM +0200, Paul Sheer wrote:
> I have a Samsung Story external USB-2.0 1.5TB drive that fails to
> detect as a device in more recent kernel versions. Full kmsg details
> are below. Note that a USB thumb drive works fine on my system.
> Older kernels work fine with the Samsung also. In terms of which
> version of the kernel this stopped working, this I don't know.
> 

Can you bisect this problem maybe?

Daniel
