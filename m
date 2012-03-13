Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2CMQiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:38:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39569 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2CMQiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120313100024.GG18973@amd.com>
References: <017a01ccfdee$4e5e7a00$eb1b6e00$%cho@samsung.com>
	<20120312150156.GF18973@amd.com>
	<CAHQjnOOCQb4G1aeFB0FQVBstXpaXmahnQO8+FoinPcQNZEieGg@mail.gmail.com>
	<20120313100024.GG18973@amd.com>
Date: Wed, 14 Mar 2012 01:38:05 +0900
X-Google-Sender-Auth: IkOOORrFOjXZ0YW7qVHu_n8FTSI
Message-ID: <CAHQjnOO2Me5C6it=M0OFKdRcK0LObDR8+hPGyuUb21oqGwsg0g@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 7:00 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> On Tue, Mar 13, 2012 at 05:50:16PM +0900, KyongHo Cho wrote:
>> >> +struct sysmmu_drvdata {
>> >> +     struct device *sysmmu;
>> >> +     char *dbgname;
>> >> +     int nsfrs;
>> >> +     void __iomem **sfrbases;
>> >> +     struct clk *clk[2];
>> >> +     int activations;
>> >> +     rwlock_t lock;
>> >> +     struct iommu_domain *domain;
>> >> +     sysmmu_fault_handler_t fault_handler;
>> >> +     unsigned long pgtable;
>> >> +     struct iommu_client client;
>> >> +};
>> >
>> > Is there any reason why 'struct iommu_client' is a seperate data
>> > structure? Otherwise it can be merged with 'truct sysmmu_drvdata'.
>
> Of course this doesn't need to be changed immediatly. I just asked if
> there was a specific reason for this seperation.
>
>> The problems will be soon fixed and I will post next patch tomorrow.
>
> Fine. Please also get the Acked-bys from the Exynos maintainer on
> patches 1 and 2 at least. I'll merge it then.
>
Thank you.
AFAIK, Exynos maintainer is somewhat busy for his own job.
I will ask him to ack my patch soon.

Best regards,

Cho KyongHo.
