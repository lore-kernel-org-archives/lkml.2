Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2JJXFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:05:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49022 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620Ab2JJXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:47 -0400
X-Sasl-enc: rVoA5M31uid2YeqdA42mNJ7IkvWvjQ4bSCg95D0lbxsc 1349910226
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wang Xingchao <xingchao.wang@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 074/122] ALSA: hda - Add another pci id for Haswell board
Date: Thu, 11 Oct 2012 07:54:00 +0900
Message-Id: <20121010225351.431154800@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Xingchao <xingchao.wang@intel.com>

commit d279fae8a41690ec1b20c07be8c6f42f8af27a17 upstream.

A new PCI id 0x0d0c for Haswell HDA Controller.

[root@SKBM04SDP ~]# lspci |grep Audio
00:03.0 Audio device: Intel Corporation Device 0d0c (rev 02)
00:1b.0 Audio device: Intel Corporation Lynx Point HD Audio Controller

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3285,6 +3285,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	{ PCI_DEVICE(0x8086, 0x0c0c),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |
 	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
+	{ PCI_DEVICE(0x8086, 0x0d0c),
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |
+	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |


