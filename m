Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2CDXWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 18:22:21 -0500
Received: from 1wt.eu ([62.212.114.60]:62807 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab2CDXWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 18:22:19 -0500
Date: Mon, 5 Mar 2012 00:22:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.58
Message-ID: <20120304232210.GR20538@1wt.eu>
References: <20120304180911.GA7336@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120304180911.GA7336@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 10:09:11AM -0800, Greg KH wrote:
> I'm announcing the release of the 2.6.32.58 kernel.
> 
> All users of the 2.6.32 kernel series must upgrade.
> 
> ************************************************************************
> Note:
> 	This is the last 2.6.32 kernel I will be releasing.  The 2.6.32
> 	kernel is now in "extended-longterm" maintenance, with no set
> 	release schedule from now on.  I STRONGLY encourage any users of
> 	the 2.6.32 kernel series to move to the 3.0 series at this point
> 	in time.
> ************************************************************************

In order to second this statement, I'm (re-)announcing that I'm going
to take over 2.6.32 maintenance at a much slower pace, similar to the
2.6.27 branch (which also continues). In short, this means that while
critical fixes might cause a quick release, non-critical ones will wait
longer before being backported.

If you need quick fixes, you need 3.0. If you can't reboot your servers
often enough to be concerned by delayed fixes, you might support sticking
to 2.6.32 for a while.

Willy

