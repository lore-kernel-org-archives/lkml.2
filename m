Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1IWIjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:39:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41765 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1IWIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:39:20 -0400
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 10:39:19 +0200
Message-ID: <CA+TfDQZJTmGQbzQpsbZSFY2rJe5gD58ik5LqRVWF36kipPU1Qw@mail.gmail.com>
Subject: Where has EMC multipath support (DM_MULTIPATH_EMC) gone, starting at 2.6.27?
From: Metathronius Galabant <m.galabant@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I'm having trouble configuring a multipath'ed EMC Clariion on recent
kernels and I seem to be missing "EMC CX/AX multipath support".
The current config has all the dm stuff, plus CONFIG_SCSI_DH_EMC=m
but the EMC volumes/multipathing are not coming up at all. I think
DM_MULTIPATH_EMC is the culprit, which is nowhere to be found anymore?
Arch is x86_64, Kernel version 2.6.39.4.

There it is:
https://github.com/torvalds/linux/blame/v2.6.26/drivers/md/Kconfig

There it isn't anymore:
https://github.com/torvalds/linux/blame/v2.6.27/drivers/md/Kconfig

Any pointers are welcome. Google searches were awfully quiet in that
regard, too.
Cheers and thanks,
M.
