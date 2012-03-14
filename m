Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031255Ab2CNX5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:57:09 -0400
Received: from HSI-KBW-46-237-235-162.hsi.kabel-badenwuerttemberg.de ([46.237.235.162]:38316
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031176Ab2CNX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:57:04 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 19:57:04 EDT
Message-Id: <20120314233544.629616190@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 00:35:44 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V2 PATCH 0/2] Provide workarounds to use DRM/KMS with broken graphics hardware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is V2 of a patchset to use DRM/KMS with broken graphics hardware.

As a major change from V1, generic EDID data are now built-in into the
drm_kms_helper module as proposed by Alan. To help people building
their own EDID data and to understand how the binary EDID blobs in
drivers/gpu/drm/drm_edid_load.c have been created, the entire material
went into the Documentation tree as suggested by Valdis. Finally, David
showed a much better way to explicitly disable and enable a particular
connector, so patch 02/03 could go.

The two remaining patches
- introduce a mechanism to define or load EDID data instead of letting the
controller probe for it,
- add a parameter to the i915 module to invert the sense of the backlight
brightness variable for broken controllers that require this.

	-Carsten.

