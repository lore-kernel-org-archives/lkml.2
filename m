Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0CQDaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:30:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:36377 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0CQDaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:30:22 -0400
Date: Tue, 16 Mar 2010 23:30:10 -0400
From: tytso@mit.edu
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100317033010.GE8256@thunk.org>
Mail-Followup-To: tytso@mit.edu, Ben Gamari <bgamari.foss@gmail.com>,
	linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
	martin f krafft <madduck@madduck.net>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
 <20100317012439.GA8256@thunk.org>
 <4ba049f1.017ee70a.5ce6.1456@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ba049f1.017ee70a.5ce6.1456@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 08:18:09PM -0700, Ben Gamari wrote:
> Sorry about the lack of any useful information in my initial email.
> I clearly didn't read it before sending.
> 
> On Tue, 16 Mar 2010 21:24:39 -0400, tytso@mit.edu wrote:
> > What kernel version are you using; what distribution and what version
> > of that distro are you running; what file system are you using and
> > what if any mount options are you using?  And what kind of hard drives
> > do you have?
> 
> While this problem has been around for some time, my current configuration
> is the following:
> 
>   Kernel 2.6.32 (although also reproducible with kernels at least as early as 2.6.28)
>   Filesystem: Now Btrfs (was ext4 less than a week ago), default mount options
>   Hard drive: Seagate Momentus 7200.4 (ST9500420AS)
>   Distribution: Ubuntu 9.10 (Karmic)

.... so did switching to Btrfs solve your latency issues, or are you
still having problems?

						- Ted
