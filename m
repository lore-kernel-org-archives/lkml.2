Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030734Ab2CSQE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:04:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49331 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2CSQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:04:26 -0400
Date: Mon, 19 Mar 2012 11:04:16 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, romain@orebokech.com,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ 05/38] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120319160415.GE11180@burratino>
References: <20120316233447.747702375@linuxfoundation.org>
 <4F670872.2090700@suse.cz>
 <20120319154633.GA8176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319154633.GA8176@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Mar 19, 2012 at 11:20:34AM +0100, Jiri Slaby wrote:

>> The commit below is reported to crash the machine in the early init. See
>> the first reply to this message (lkml.org seems to be down right now):
>> lkml.org/lkml/2012/3/18/132
>
> Yes, but this patch fixes machines that others have been reporting
> problems with, so, what am I supposed to do?
>
> I'll stick with this patch for now, and hope that Matthew fixes this up
> in Linus's tree and I'll suck that fix in when it gets there.  Is that
> ok?

Just one data point from a distro perspective: regressions are way
more painful than problems that already existed.  So it seems worth
considering dropping the patch for now and grabbing the patch and fix
when ready.
