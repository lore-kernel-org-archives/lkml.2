Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1AWSp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:45:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:3058 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1AWSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:45:59 -0500
Message-Id: <0d30dc$kr9u7e@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,366,1291622400"; 
   d="scan'208";a="699726062"
Date: Sun, 23 Jan 2011 18:45:54 +0000
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Use cachable mapping for i915 opregion.
References: <1295803414-5373-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1295803414-5373-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 18:23:34 +0100, Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> wrote:
> The opregion is a shared memory region between ACPI and the graphics
> driver. As the ACPI mapping has been changed to cachable in commit
> 6d5bbf00d251cc73223a71422d69e069dc2e0b8d, mapping the intel opregion
> non-cachable now fails. As no bus-master hardware is involved in the
> opregion, cachable map should do no harm.

Satisfied myself that is indeed equivalent to use the newly introduced
acpi_os_ioremap for this purpose and applied to -fixes.
Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
