Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2FTJjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:39:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2FTJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:39:20 -0400
MIME-Version: 1.0
Date: Wed, 20 Jun 2012 15:09:20 +0530
Message-ID: <CAKB833nfHQwdHzCFV6ELrk1-XZT-SN8WxMs=kzO=C8+6foTrDQ@mail.gmail.com>
Subject: Need help regarding the USB mass storage driver
From: Vishal Nandanwar <operational.people@gmail.com>
To: Linux Docs <linux-doc@vger.kernel.org>,
        Linux Embedded Group <linux-embedded@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a USB mass storage driver for a pen drive. I have done
coding as per the USB_skeleton.c file provided in Linux 3.2 source
code. I could assign the driver to pen drive when pen driver is
inserted in USB connector.

I am stuck in data transfer,  could not do the data transfer. During
enumeration interface sub class is 06 i.e. SCSI transparent command
set. Please find my questions below.

1. Where are these SCSI transparent command set documented?
2. Is there any sample code(apart from Linux source) which describes
the SCSI transparent command set and mass storage driver?
3. When I connect the pen drive and associate my driver, pop up
doesn't appear on the screen for this device. but when default
driver(usb_storage) is used this pop up does appear. What I need to do
here?

Any thing other I need to take care here?

Vishal N
