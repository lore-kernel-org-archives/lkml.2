Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2KWPMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:12:49 -0500
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:44558 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab2KWPMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:12:47 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2012 10:12:47 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
X-IronPort-AV: E=Sophos;i="4.83,307,1352070000";   d="scan'208";a="200816512"
Date: Fri, 23 Nov 2012 15:42:49 +0100
From: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>
Subject: nouveau driver fails to build
To: linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.4.91
Message-id: <1353681769.29421.0@numa-i>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 3.7_rc6 and

CONFIG_ACPI_VIDEO=m
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y

with/ without
CONFIG_DRM_LOAD_EDID_FIRMWARE=y


The kernel fails to build with
drivers/built-in.o: In function `nouveau_acpi_edid':
(.text+0x12bf21): undefined reference to `acpi_video_get_edid'


What am I missing?

Thanks,
Helmut.
