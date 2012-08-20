Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2HTS1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:27:48 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:16384 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2HTS1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:27:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1345487248!24746548!21
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] staging: comedi: update the aio_aio12_8 driver
Date: Mon, 20 Aug 2012 11:27:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201127.31095.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten (4):
  staging: comedi: aio_aio12_8: remove devpriv macro
  staging: comedi: aio_aio12_8: add ai and ao only card versions
  staging: comedi: aio_aio12_8: document the register map
  staging: comedi: aio_aio12_8: fix i/o region size

 drivers/staging/comedi/drivers/aio_aio12_8.c | 226 +++++++++++++++++----------
 1 file changed, 141 insertions(+), 85 deletions(-)

-- 
1.7.11

