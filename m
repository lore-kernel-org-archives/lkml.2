Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2KTWXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:23:16 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2KTWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:23:15 -0500
MIME-Version: 1.0
Date: Tue, 20 Nov 2012 14:23:14 -0800
X-Google-Sender-Auth: JdjDaNP1Krj3FxeuO2c99nUqRN4
Message-ID: <CAPnjgZ0+8MbjmW7XKsSW0O0n2ob7XcUZokLd8b=1LkSUJ+tQEA@mail.gmail.com>
Subject: Device tree node to major/minor?
From: Simon Glass <sjg@chromium.org>
To: lk <linux-kernel@vger.kernel.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Che-liang Chiou <clchiou@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hope this is a stupid question with an easy answer, but I cannot find it.

I have a device tree node for an mmc block device and I want to use
that block device from another driver. I have a phandle which lets me
get the node of the mmc device, but I am not sure how to convert that
into a block_device. In order to do so, I think I need a major/minor
number. Of course the phandle might in fact point to a SCSI driver and
I want that to work correctly also.

I imagine I might be able to search through the wonders of sysfs in
user space, but is there a better way?

Thanks,
Simon
