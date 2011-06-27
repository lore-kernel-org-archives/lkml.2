Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1F0Uke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:40:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:15537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab1F0UkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,434,1304319600"; 
   d="scan'208";a="20728384"
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        mjg59@srcf.ucam.org
Subject: Re: [PATCH -v2 0/4] ACPI, APEI, Add APEI related _OSC support
References: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
Date: Mon, 27 Jun 2011 13:38:47 -0700
In-Reply-To: <1309163160-3201-1-git-send-email-ying.huang@intel.com> (Huang
	Ying's message of "Mon, 27 Jun 2011 16:25:56 +0800")
Message-ID: <m27h872enc.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> Changes:
>
> - Change error message for WHEA _OSC call according to Matthew's comments
>
> [PATCH -v2 1/4] ACPI, APEI, GHES, Prevent GHES to be built as module
> [PATCH -v2 2/4] ACPI, APEI, GHES, Support disable GHES at boot time
> [PATCH -v2 3/4] ACPI, APEI, Add APEI bit support in generic _OSC call
> [PATCH -v2 4/4] ACPI, APEI, Add WHEA _OSC support

FWIW I reviewed the patch-kit and it all looks good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
