Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0DDXmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:42:15 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:51339 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0DDXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:42:09 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Apr 2010 19:42:09 EDT
Date: Mon, 5 Apr 2010 01:31:33 +0200
From: =?iso-8859-1?B?R+Fib3IgTOlu4XJ0?= <lgb@lgb.hu>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Message-ID: <20100404233133.GB20453@vega.lgb.hu>
Reply-To: lgb@lgb.hu
References: <20100404221349.GA18036@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404221349.GA18036@rhlx01.hs-esslingen.de>
X-Operating-System: vega Linux 2.6.32-16-generic i686
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 12:13:49AM +0200, Andreas Mohr wrote:
> I was just running
> mkfs.ext4 -b 4096 -E stride=128 -E stripe-width=128 -O ^has_journal
> /dev/sdb2
> on my SSD18M connected via USB1.1, and the result was, well,
> absolutely, positively _DEVASTATING_.
> 
> The entire system became _FULLY_ unresponsive, not even switching back
> down to tty1 via Ctrl-Alt-F1 worked (took 20 seconds for even this key
> to be respected).

It seems it's a major issue with recent kernels, at least I have the same
with >2.6.30 ones, mainly with pendrives on USB port, even if I only
download from the net directly to the pendrive, it seems no I/O can be
served towards the hdd either in a reasonable speed and a responsive way,
window manager took 10 mins to draw window borders and so on ...
