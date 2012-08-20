Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HTVaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:30:09 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:19673 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2HTVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:30:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1345498174!8069538!43
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] staging: comedi: cleanup comedi_parport
Date: Mon, 20 Aug 2012 14:29:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201429.41421.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten (4):
  staging: comedi: comedi_parport: remove devpriv macro
  staging: comedi: comedi_parport: cleanup dev->board_name
  staging: comedi: comedi_parport: cleanup 'attach' printk's
  staging: comedi: comedi_parport: remove the printk noise

 drivers/staging/comedi/drivers/comedi_parport.c | 39 +++++++++++++++----------
 1 file changed, 24 insertions(+), 15 deletions(-)

-- 
1.7.11

