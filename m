Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2FZRGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:06:05 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:10213 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab2FZRGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:06:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1340730358!6540795!6
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] staging: comedi: cd_das16_cs: additional cleanup
Date: Tue, 26 Jun 2012 10:05:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261005.35947.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple minor issues in cb_das16_cs driver that were
pointed out by Ian Abbott.

This is an incremental patch to the series:

[PATCH 00/33] staging: comedi: cb_das16_cs: cleanup the driver

H Hartley Sweeten (2):
  staging: comedi: cb_das16_cs: reword the comment about PCMCIA support
  staging: comedi: cb_das16_cs: remove unneeded default case in analog
    in read

 drivers/staging/comedi/drivers/cb_das16_cs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
1.7.11

