Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162169Ab2CSQd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:33:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54125 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161769Ab2CSQd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:33:27 -0400
Date: Mon, 19 Mar 2012 11:33:10 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, romain@orebokech.com,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ 05/38] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120319163310.GB13050@burratino>
References: <20120316233447.747702375@linuxfoundation.org>
 <4F670872.2090700@suse.cz>
 <20120319154633.GA8176@kroah.com>
 <20120319160415.GE11180@burratino>
 <20120319162516.GA3694@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319162516.GA3694@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> I think you are missing the fact that this patch itself is fixing a
> regression from a previous patch :)

My logic was that 10f6dc7eede9 (PCI: Rework ASPM disable code) has
been in wide use for a while, so any regression introduced by that
patch was likely to be rare or minor.

What I missed is that the backport of 4949be16822e (PCI: ignore
pre-1.1 ASPM quirking when ASPM is disabled) is already part of a
3.0.y release, so there's no use now in considering dropping it.

So, nothing to see here. :)  Thanks for explaining.

Cheers,
Jonathan
