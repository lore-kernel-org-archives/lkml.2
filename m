Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1LSBYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:24:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:3594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1LSBYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:24:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87916593"
Message-ID: <1324257869.4639.1.camel@yhuang-dev>
Subject: RE: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
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
Date: Mon, 19 Dec 2011 09:24:29 +0800
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7ADB5@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
	 <1321581563.13860.111.camel@yhuang-dev>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57B4FA66@USINDEVS01.corp.hds.com>
	 <1321836227.13860.121.camel@yhuang-dev>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7ADB5@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-3+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 00:03 +0800, Seiji Aguchi wrote:
> Hi,
> 
> >
> >No.  I have different understanding.
> >
> >Because error log address range resides in NVRAM, the contents will be
> >reserved even after reboot.  So we do not need read/clear operations at
> >all, and should place all records in error log address range.
> 
> I have a quick question about your comment above.
> Do you know whether this optimization of read/clear operations works 
> on machines which APEI is enabled by WHEA _OSC call?

I have no machine with

!!(erst_erange.attr & ERST_RANGE_NVRAM) == 1

Do you have?

Best Regards,
Huang Ying


