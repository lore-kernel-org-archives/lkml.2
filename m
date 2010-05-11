Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0EKSgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:36:46 -0400
Received: from claw.goop.org ([74.207.240.146]:37608 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0EKSgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:36:45 -0400
Message-ID: <4BE9A3BA.5090908@goop.org>
Date: Tue, 11 May 2010 11:36:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Albert Herranz <albert_herranz@yahoo.es>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, dwmw2@infradead.org
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible
 in the header file.
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com> <4BE9A1C0.3090505@yahoo.es>
In-Reply-To: <4BE9A1C0.3090505@yahoo.es>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 11:28 AM, Albert Herranz wrote:
> Konrad Rzeszutek Wilk wrote:
>   
>> +extern void *swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
>> +				    u64 tbl_dma_addr, size_t size,
>> +				    enum dma_data_direction dir);
>> +
>>     
> The phys and tbl_dma_addr arguments in the function prototype are swapped compared to the function definition in patch 1/6.
>   

Good catch.  I can see someone beating their head bloody over that...

    J
