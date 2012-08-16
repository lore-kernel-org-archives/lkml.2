Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2HPA2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:28:55 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:28887 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2HPA2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:28:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1345076932!7556713!7
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] staging: comedi: update the contec_pci_dio driver
Date: Wed, 15 Aug 2012 17:28:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151728.19586.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the need for the boardinfo, this driver only supports one board type.
Convert the driver to use the comedi PCI auto config (attach_pci).
Cleanup the digital output insn_bits function.

H Hartley Sweeten (7):
  staging: comedi: contec_pci_dio: remove thisboard macro
  staging: comedi: contec_pci_dio: remove function trace messages
  staging: comedi: contec_pci_dio: remove unused fields in the
    boardinfo
  staging: comedi: contec_pci_dio: define register map for board
  staging: comedi: contec_pci_dio: remove unneeded boardinfo code
  staging: comedi: contec_pci_dio: use attach_pci callback
  staging: comedi: contec_pci_dio: cleanup contec_do_insn_bits

 drivers/staging/comedi/drivers/contec_pci_dio.c | 146 ++++++++----------------
 1 file changed, 50 insertions(+), 96 deletions(-)

-- 
1.7.11

