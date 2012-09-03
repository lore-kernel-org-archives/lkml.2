Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2ICADW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:03:22 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:59581 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755075Ab2ICADV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:03:21 -0400
X-Greylist: delayed 2157 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 20:03:21 EDT
Subject: [PATCH 0/5] acpi: remove some legacy procfs interfaces
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 03 Sep 2012 02:03:18 +0200
Message-ID: <1346630598.3170.28.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is a first attempt to remove some of the deprecated procfs
ACPI interfaces - in the final overall idea to remove /proc/acpi entirely. 
Based on the feature removal file, the CONFIG_ACPI_PROCFS_POWER and CONFIG_ACPI_PROC_EVENT
options are dropped.

patch 1: removes CONFIG_ACPI_PROCFS_POWER
patch 2-5: removes CONFIG_ACPI_PROC_EVENT for acpi and respective drivers
that use /proc/acpi/event.

The set applies ontop of Linus' latest.

Thanks,
Davidlohr


