Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836Ab0HFS2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:28:22 -0400
Received: from kroah.org ([198.145.64.141]:36030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761797Ab0HFS2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:28:19 -0400
Date: Fri, 6 Aug 2010 11:27:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/4] 2.6.27.50-stable review
Message-ID: <20100806182735.GA15732@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.50 release.
There are 4 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by August 8, 2010, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.50-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                 |    2 +-
 drivers/misc/enclosure.c |    7 +++++--
 drivers/parisc/led.c     |    6 ++++--
 fs/gfs2/dir.c            |    2 +-
 fs/xfs/xfs_dfrag.c       |    5 ++++-
 5 files changed, 15 insertions(+), 7 deletions(-)
