Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0HRUcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:32:50 -0400
Received: from kroah.org ([198.145.64.141]:42287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab0HRUcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:32:46 -0400
Date: Wed, 18 Aug 2010 13:31:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/3] 2.6.35.3 -stable review
Message-ID: <20100818203148.GA1115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.35.3 release.
Yeah, it's a bugfix for the .35.2 kernel, for issues found in that
release.

There are 3 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 20, 2010 10:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                     |    2 +-
 arch/x86/kernel/cpu/vmware.c |    1 +
 fs/proc/task_mmu.c           |    8 +++++++-
 mm/memory.c                  |   13 ++++++-------
 mm/mlock.c                   |    8 ++++++++
 5 files changed, 23 insertions(+), 9 deletions(-)
