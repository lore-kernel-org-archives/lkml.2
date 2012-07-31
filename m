Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2GaU5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:57:03 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56779 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2GaU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <50174F0A.8020509@kernel.org>
References: <1342683564-2245-1-git-send-email-feng.tang@intel.com>
	<50174F0A.8020509@kernel.org>
Date: Tue, 31 Jul 2012 13:56:58 -0700
X-Google-Sender-Auth: UFILPOPiqk2TsrjDhxXo_4lmnxA
Message-ID: <CAE9FiQW+0dSDXQn-q18yjPUnExmQB_fq0vFbR7E0oN-KLF3Q+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ACPI: replace all acpi_get_table_with_size with acpi_get_table
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Donald Dutile <ddutile@redhat.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 8:20 PM, Len Brown <lenb@kernel.org> wrote:
> Applied.
>
> thanks,
> Len Brown, Intel Open Source Technology Center
>
> ps. next time, please send to linux-acpi@vger.kernel.org list
> also, put comments not for the commit log after the "---"
>

other two reference need to be changed:

drivers/iommu/amd_iommu_init.c: status =
acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);
drivers/iommu/amd_iommu_init.c: status =
acpi_get_table_with_size("IVRS", 0, &ivrs_base, &ivrs_size);


Thanks

Yinghai
