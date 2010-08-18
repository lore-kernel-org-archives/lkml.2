Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0HRU2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:28:38 -0400
Received: from kroah.org ([198.145.64.141]:42263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0HRU2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:28:33 -0400
Date: Wed, 18 Aug 2010 13:27:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 0/3] 2.6.34.5 stable review
Message-ID: <20100818202723.GA547@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.34.5 release, a
"fix the .34.6 release" to resolve problems found in that kernel
version.

There are 3 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 20, 2010 10:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.34.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                     |    2 +-
 arch/x86/kernel/cpu/vmware.c |    1 +
 fs/proc/task_mmu.c           |    8 +++++++-
 mm/memory.c                  |   13 ++++++-------
 mm/mlock.c                   |    8 ++++++++
 5 files changed, 23 insertions(+), 9 deletions(-)
