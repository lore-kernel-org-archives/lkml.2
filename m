Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1DFUft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:35:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48282 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab1DFUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:35:48 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Eric Cooper <ecc@cmu.edu>
Subject: [PATCH 0/2] ARM: Unify setup for Marvell SheevaPlugs and Seagate DockStars
Date: Wed,  6 Apr 2011 22:35:19 +0200
Message-Id: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it seems the time is right to submit these 2 patches.

The first patch merges the setup for Seagate DockStars into the setup
for Marvell SheevaPlugs and the second one removes the machine type for
DockStars at all.

Removing the machine type for DockStar shouldn't be a big problem. Support
for them is already broken in mainline U-Boot since 2 versions, so changing the
stuff there is already needed and it shouldn't be a problem to use the same
machine type as used for SheevaPlugs there.

And if someone really can't change his bootloader to use the same machine type
for DockStars as for SheevaPlugs, he still could revert the second patch.

Regards,

Alexander Holler
