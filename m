Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1CTVvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 17:51:36 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51922 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1CTVvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 17:51:32 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com, Florian Mickler <florian@mickler.org>
Subject: [PATCH 0/5] get rid of on-stack dma buffers (part1)
Date: Sun, 20 Mar 2011 22:50:47 +0100
Message-Id: <1300657852-29318-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro!

These are the patches which got tested already and 
should be good to go. [first batch of patches]

I have another batch with updated patches (dib0700, gp8psk, vp702x)
where I did some more extensive changes to use preallocated memory.
And a small update to the vp7045 patch.

Third batch are the patches to opera1, m920x, dw2102, friio,
a800 which I left as is, for the time beeing. 
Regards,
Flo

Florian Mickler (5):
  [media] ec168: get rid of on-stack dma buffers
  [media] ce6230: get rid of on-stack dma buffer
  [media] au6610: get rid of on-stack dma buffer
  [media] lmedm04: correct indentation
  [media] lmedm04: get rid of on-stack dma buffers

 drivers/media/dvb/dvb-usb/au6610.c  |   22 ++++++++++++++++------
 drivers/media/dvb/dvb-usb/ce6230.c  |   11 +++++++++--
 drivers/media/dvb/dvb-usb/ec168.c   |   18 +++++++++++++++---
 drivers/media/dvb/dvb-usb/lmedm04.c |   35 +++++++++++++++++++++++------------
 4 files changed, 63 insertions(+), 23 deletions(-)

-- 
1.7.4.1

