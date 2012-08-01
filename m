Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2HACLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 22:11:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:23869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab2HACLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 22:11:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="191603582"
Date: Wed, 1 Aug 2012 10:06:52 +0800
From: Feng Tang <feng.tang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Donald Dutile <ddutile@redhat.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/2] ACPI: replace all acpi_get_table_with_size with
 acpi_get_table
Message-ID: <20120801100652.23712b3e@feng-i7>
In-Reply-To: <CAE9FiQW+0dSDXQn-q18yjPUnExmQB_fq0vFbR7E0oN-KLF3Q+g@mail.gmail.com>
References: <1342683564-2245-1-git-send-email-feng.tang@intel.com>
	<50174F0A.8020509@kernel.org>
	<CAE9FiQW+0dSDXQn-q18yjPUnExmQB_fq0vFbR7E0oN-KLF3Q+g@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012 13:56:58 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Jul 30, 2012 at 8:20 PM, Len Brown <lenb@kernel.org> wrote:
> > Applied.
> >
> > thanks,
> > Len Brown, Intel Open Source Technology Center
> >
> > ps. next time, please send to linux-acpi@vger.kernel.org list
> > also, put comments not for the commit log after the "---"
> >
> 
> other two reference need to be changed:
> 
> drivers/iommu/amd_iommu_init.c: status =
> acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);
> drivers/iommu/amd_iommu_init.c: status =
> acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);

Thanks for the reminder! I will send a follow-on patch

Thanks,
Feng

> 
> 
> Thanks
> 
> Yinghai
