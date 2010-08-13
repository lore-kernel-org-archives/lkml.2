Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0HMVsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:48:45 -0400
Received: from kroah.org ([198.145.64.141]:51671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab0HMVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:48:44 -0400
Date: Fri, 13 Aug 2010 14:47:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/3] 2.6.27.52 stable review
Message-ID: <20100813214704.GA18960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE!

If I could get some people to please test this -rc release?  It contains
a few core changes that I couldn't validate myself as I don't seem to
have a machine that will even boot the .27 kernel anymore after my move.

I didn't want to include them in the last .27-stable release because of
this, so any testing is much appreciated.  Especially if you happen to
run across any signal and/or stack issues that might be floating around
in the ether...

----

This is the start of the stable review cycle for the 2.6.27.52 release.
There are 3 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, August 16, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.52-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile            |    2 +-
 arch/x86/mm/fault.c |    9 ++++++++-
 mm/memory.c         |   25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)
