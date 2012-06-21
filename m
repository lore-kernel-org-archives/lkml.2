Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab2FUCXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:23:08 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:24707 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab2FUCXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:23:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1340245384!6384357!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/12] staging: comedi: s626: start cleaning up the driver
Date: Wed, 20 Jun 2012 19:22:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201922.58120.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s626 driver is a bit of a mess...

Start cleaning it up by getting rid of some sparse warnings, all the
forward declarations, the DEBUG function tracing, an unused
macro, and factoring out the PCI device matching code.

H Hartley Sweeten (12):
  staging: comedi: s626: local functions should not be exposed globally
  staging: comedi: s626: pointers should be cleared with NULL not 0
  staging: comedi: s626: remove forward declarations 1
  staging: comedi: s626: remove forward declarations 2
  staging: comedi: s626: remove forward declarations 3
  staging: comedi: s626: remove forward declarations 4
  staging: comedi: s626: remove forward declarations 5
  staging: comedi: s626: remove forward declarations 6
  staging: comedi: s626: remove forward declarations 7
  staging: comedi: s626: remove private DEBUG macro
  staging: comedi: s626: remove private INLINE macro
  staging: comedi: s626: factor out the find PCI device code

 drivers/staging/comedi/drivers/s626.c | 3075 +++++++++++++++------------------
 drivers/staging/comedi/drivers/s626.h |   10 -
 2 files changed, 1377 insertions(+), 1708 deletions(-)

-- 
1.7.11

