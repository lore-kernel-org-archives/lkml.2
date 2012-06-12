Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2FLS41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:56:27 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:6284 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2FLS40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:56:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1339527379!8245307!21
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] staging: comedi: cleanup alloc_subdevices
Date: Tue, 12 Jun 2012 11:56:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206121156.11447.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the comedi core "alloc_subdevices" function and it's use
in the comedi drivers.

staging: comedi: add namespace to comedi's alloc_subdevices() function
staging: comedi: change type of num_subdevices parameter to comedi_alloc_subdevices
staging: comedi: sanity check num_subdevices parameter in comedi_alloc_subdevices
staging: comedi: only set dev->n_subdevices when kcalloc succeedes
staging: comedi: remove the comed_alloc_subdevices "allocation failed" messages
staging: comedi: remove the "Allocate the subdevice..." comments
staging: comedi: propogate error code from comedi_alloc_subdevices
staging: comedi: cleanup comedi_alloc_subdevices

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
