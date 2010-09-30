Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0I3ALv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:11:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:43948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab0I3ALs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:11:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,257,1283756400"; 
   d="scan'208";a="611747988"
Subject: Re: [PATCH -v2 1/5] ACPI, APEI, Fix APEI related table size
 checking
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <AANLkTi=JkcJiQhxLSmU2vgmrACPSrE16cEhRnxCOr_5g@mail.gmail.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
	 <1285761235-4751-2-git-send-email-ying.huang@intel.com>
	 <AANLkTi=JkcJiQhxLSmU2vgmrACPSrE16cEhRnxCOr_5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 08:11:46 +0800
Message-ID: <1285805506.6944.4.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Yinghai,

On Wed, 2010-09-29 at 23:47 +0800, Yinghai Lu wrote:
> On Wed, Sep 29, 2010 at 4:53 AM, Huang Ying <ying.huang@intel.com> wrote:
> > On Huang Ying's machine:
> >
> > erst_tab->header_length == sizeof(struct acpi_table_einj)
> 
> So it seems your system firmware violates the 4.0 spec

Perhaps. :)

But the machine firmware has been released, and we should support as
many machines as possible I think. Do you agree?

Best Regards,
Huang Ying


