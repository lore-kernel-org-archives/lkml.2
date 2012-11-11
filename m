Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2KKFUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:20:53 -0500
Received: from mout.web.de ([212.227.15.4]:49335 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2KKFUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:20:50 -0500
Subject: [PATCH 0/7] HID: roccat: Finishing cleanup and reset support
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:20:46 +0100
Message-ID: <1352611246.2463.214.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:B06ISkfJZVSrFzRujUY+xdUiNjfN6w3KMrjE/QQte4H
 i9ElhOvt+XsruMPlC8+BRHxhrwLIMn4+la7M3ygHlxqIydpRQu
 /Vy5XpbPOczUdbq9hwXrf9qdkZagXFx5pGhUSZyY9ypwvwbT1G
 Azr6VTyRxGW7LUa6qysCgeYLmOxhPeTh8tKzt7O6uz0RXnw4Hr
 mq7+dmHUctwtGYhd3BAOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset finishes current cleanups and unifications.

Device reset is now implemented for all devices that support that
feature.

A couple sysfs attributes have been deprecated and got replaced to unify
the ABI as good as it gets with design decisions made in the past.

The next release of userland tools will only use these obsolete
attributes as fallback. When that version is out, I will add all actual
sysfs attributes from ABI/obsolete/sysfs-driver-hid-roccat-* to
feature-removal-schedule.txt.

