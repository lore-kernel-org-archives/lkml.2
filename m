Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2F2R5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:57:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:33554 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2F2R5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:57:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1340992651!8239501!36
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] staging: comedi: das_08: cleanup the 8254 timer subdevice
Date: Fri, 29 Jun 2012 10:57:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291057.24628.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8253.h header provides all the functionality needed for the 8254
timer subdevice. Remove all the internal support in the driver and
use the support provided in the header.

H Hartley Sweeten (7):
  staging: comedi: das_08: use the 8253 helper functions
  staging: comedi: das_08: unwind the 8254 timer support
  staging: comedi: das_08: remove the cached 8254 'mode'
  staging: comedi: das_08: remove the 8254 'logic2phys' usage
  staging: comedi: das_08: remove the 8254 'channels' usage
  staging: comedi: das_08: remove the unneeded 8254 variables and
    defines
  staging: comedi: das_08: absorb i8254_struct into the private data

 drivers/staging/comedi/drivers/das08.c | 110 +++++----------------------------
 drivers/staging/comedi/drivers/das08.h |  14 +----
 2 files changed, 16 insertions(+), 108 deletions(-)

-- 
1.7.11

