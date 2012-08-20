Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2HTWEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:04:13 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:23843 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2HTWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:04:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1345500246!8075836!5
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: comedi: cleanup conedi_test driver
Date: Mon, 20 Aug 2012 15:04:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201504.04320.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten (3):
  staging: comedi: comedi_test: remove devpriv macro
  staging: comedi: comedi_test: remove boardinfo
  staging: comedi: comedi_test: convert attach message to dev_info

 drivers/staging/comedi/drivers/comedi_test.c | 61 ++++++++++++----------------
 1 file changed, 27 insertions(+), 34 deletions(-)

-- 
1.7.11

