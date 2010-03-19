Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0CSHkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:40:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:28778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0CSHkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:40:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,273,1267430400"; 
   d="scan'208";a="256482271"
Subject: Re: [PATCH -v3 0/2] ACPI, APEI, use general HEST tabling parsing
 in AER firmware_first setup
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <1268636261-31554-1-git-send-email-ying.huang@intel.com>
References: <1268636261-31554-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 15:40:03 +0800
Message-ID: <1268984403.3596.14.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

What do you think about this patchset?

Best Regards,
Huang Ying

On Mon, 2010-03-15 at 14:57 +0800, Huang, Ying wrote:
> Changelog:
> 
> v3:
> 
> - Move pcie_aer_get_firmware_first into aerdrv_acpi.c, and make
>   aer_set_firmware_first static in aerdrv_acpi.c. This makes external
>   interface simple and clear.
> 
> v2:
> 
> - Setup firmware_first for every PCIE end point instead of just root point.
> 
> - Wrap firmware_first accessing in a function, because HEST parsing involved.


