Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2HTTwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:52:37 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:36045 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2HTTwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:52:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1345492342!22140901!20
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] staging: comedi: cleaup comedi_bond driver
Date: Mon, 20 Aug 2012 12:52:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201252.20432.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten (5):
  staging: comedi: comedi_bond: remove boardinfo
  staging: comedi: comedi_bond: remove devpriv macro
  staging: comedi: comedi_bond: remove private printk macros
  staging: comedi: comedi_bond: remove the STR macro
  staging: comedi: comedi_bond: remove MODULE_NAME macro

 drivers/staging/comedi/drivers/comedi_bond.c | 108 ++++++++-------------------
 1 file changed, 30 insertions(+), 78 deletions(-)

-- 
1.7.11

