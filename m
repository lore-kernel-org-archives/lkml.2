Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2HSIVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:21:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39245 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2HSIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:21:22 -0400
Date: Sun, 19 Aug 2012 12:21:17 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Shaun Ruffell <sruffell@digium.com>
Cc: Dave Haywood <tla@oak.selfip.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at 00010016
Message-ID: <20120819082117.GA4634@thinkpad.lan>
References: <502ECC74.9030605@oak.selfip.net>
 <20120819042543.GA14461@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120819042543.GA14461@digium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 11:25:43PM -0500, Shaun Ruffell wrote:
> Adding linux-net to the CC list.
> 
> On Fri, Aug 17, 2012 at 11:57:56PM +0100, Dave Haywood wrote:
> > [1.] One line summary of the problem:
> > BUG: unable to handle kernel paging request at 00010016
> > 
> > 	System boots then crashes a 5-10 or so seconds after getting to the login prompt
> > 	Booting without the network cable attached prevents the crash (no evidence beyond 10 minutes after boot)
> > 
> >   Diagnostics:
> > 	Captured the boot and managed a login + dmesg before the crash
> > 	Some of the log looks corrupted. Probably my crappy usb dongle serial flow control but left it in anyway
> 
> [snip]
> 
> Just a note that I see this as well. It happens reliably for me after trying to
> login to the machine via ssh.
> 
> Here is the back trace I collected on the serial port.
There is a patch posted on netdev that fixes this for me:
http://patchwork.ozlabs.org/patch/178525/

-- 
Kind regards,
Artem
