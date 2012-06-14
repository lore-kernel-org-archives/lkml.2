Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2FNCMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:12:16 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:58093 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab2FNCMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:12:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1339639904!5742709!10
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] staging: comedi: me4000: remove *PDEBUG macros
Date: Wed, 13 Jun 2012 19:11:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131911.53483.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comedi driver is _very_ chatty. Remove a lot of the noise
by getting rid of the *PDEBUG macros.

H Hartley Sweeten (5):
  staging: comedi: me4000: remove CALL_PDEBUG macro
  staging: comedi: me4000: remove PORT_PDEBUG macro
  staging: comedi: me4000: remove inline port io wrappers
  staging: comedi: me4000: remove ISR_PDEBUG macro
  staging: comedi: me4000: remove PDEBUG macro

 drivers/staging/comedi/drivers/me4000.c |  369 ++++++++----------------------
 drivers/staging/comedi/drivers/me4000.h |   37 ---
 2 files changed, 99 insertions(+), 307 deletions(-)

-- 
1.7.7

