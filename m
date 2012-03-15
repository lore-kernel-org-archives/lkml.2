Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967Ab2COK50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:57:26 -0400
Received: from HSI-KBW-109-192-167-159.hsi6.kabel-badenwuerttemberg.de ([109.192.167.159]:59545
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753444Ab2COK5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:57:25 -0400
Message-Id: <20120315095219.520461363@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 10:52:19 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V3 PATCH 0/2] Provide workarounds to use DRM/KMS with broken graphics hardware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V2 to V3:

1. The help text of the DRM_LOAD_EDID_FIRMWARE Kconfig item and the
related explanation in Documentation/kernel-parameters.txt now contain
a pointer to the documentation as suggested by Paul.
2. Removed the "brightness_inverted" parameter of the i915 module and
replaced it by a quirk that is specific to the affected Acer Aspire 5734Z
notebook as suggested by Keith.

Thanks,
	-Carsten.

