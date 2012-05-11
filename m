Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865Ab2EKRJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:09:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:50217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760489Ab2EKRJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165033165"
From: Andi Kleen <andi@firstfloor.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, liuj97@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] ACPI: Add _OST support for ACPI hotplug
References: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
Date: Fri, 11 May 2012 10:09:38 -0700
In-Reply-To: <1336754223-5346-1-git-send-email-toshi.kani@hp.com> (Toshi
	Kani's message of "Fri, 11 May 2012 10:36:56 -0600")
Message-ID: <m2vck2lk4t.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshi Kani <toshi.kani@hp.com> writes:

> This patchset supports ACPI OSPM Status Indication (_OST) method for
> ACPI CPU/memory/container hotplug operations and sysfs eject. After
> ACPI hotplug operation has completed, OSPM calls _OST to indicate the
> result of the operation to the platform. If _OST is not present, this
> patchset has no effect on the platform.
>
> This _OST support can be enabled or disabled with a new config option
> CONFIG_ACPI_HOTPLUG_OST. This option is disabled by default. When
> this option is disabled, this patchset has no effect on the platform.

Does that control compiling in/out significant sized code?

Controlling code behaviour by CONFIG option has been long deprecated.
This is always better done as a runtime option.

Just think what should a distribution who wants to use the same binary
on all systems set.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
