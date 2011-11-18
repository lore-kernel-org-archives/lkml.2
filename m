Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1KRB70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 20:59:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:24662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab1KRB7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 20:59:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,530,1315206000"; 
   d="scan'208";a="92168797"
Message-ID: <1321581563.13860.111.camel@yhuang-dev>
Subject: Re: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
From: Huang Ying <ying.huang@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, "Chen, Gong" <gong.chen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 18 Nov 2011 09:59:23 +0800
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 04:47 +0800, Seiji Aguchi wrote:
> Hi,
> 
> I developed write/read/clear functions of ERST driver for NVRAM. 
> According to ACPI 4.0 specification, we can use the same procedure as storage.
> 
> This patch is tested on DELL PowerEdge T310.

This machine has error log address range in NVRAM?

According to ACPI 4.0a spec:

"""
17.5.2.4.1 Error Log Address Range Resides in NVRAM

If the Error Log Address Range resides in NVRAM, then when OSPM writes a
record into the logging
range, the record is automatically persistent and the busy bit can be
cleared immediately. On a subsequent
boot, OSPM can read any persisted error records directly from the
persistent store range. The size of the
persistent store, in this case, is expected to be enough for several
error records.
"""

So it should not work with the same procedure.

Best Regards,
Huang Ying


