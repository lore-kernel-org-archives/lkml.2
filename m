Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2ACWEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:04:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44852 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125Ab2ACWEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:04:09 -0500
X-Sasl-enc: I6s8+/gvo9PB33pgYZYNFTinTw8ygD+VPtYSBkcz1ed5 1325628248
Date: Tue, 3 Jan 2012 14:03:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [0/7] 2.6.32.53-longterm review
Message-ID: <20120103220302.GA28338@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.@rel@ release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, January 6, 2012, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.53-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                             |    2 +-
 arch/arm/plat-mxc/pwm.c              |   16 +++++++++++++++-
 block/cfq-iosched.c                  |   11 +++++++++--
 drivers/mmc/host/mmci.c              |    6 +++++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 drivers/watchdog/hpwdt.c             |    5 ++++-
 mm/filemap.c                         |    7 ++-----
 7 files changed, 37 insertions(+), 12 deletions(-)
