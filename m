Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2IMRH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:07:28 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:10126 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab2IMRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:07:27 -0400
Message-ID: <505212A3.1030307@hp.com>
Date: Thu, 13 Sep 2012 10:06:43 -0700
From: Craig Hada <craig.hada@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Hada, Craig M" <craig.hada@hp.com>, netdev@vger.kernel.org
CC: sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net: Enable IOMMU pass through for be2net
References: <1347472734-3196-1-git-send-email-craig.hada@hp.com> <4988B24899FF4448BF3D99EFCD2A3562323AD5@G1W3785.americas.hpqcorp.net>
In-Reply-To: <4988B24899FF4448BF3D99EFCD2A3562323AD5@G1W3785.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/2012 9:27 AM, Hada, Craig M wrote:
> This patch sets the coherent DMA mask to 64-bit after the be2net driver has been acknowledged that the system is 64-bit DMA capable. The coherent DMA mask is examined by the Intel IOMMU driver to determine whether to allow pass through context mapping for all devices. With this patch, the be2net driver combined with be2net compatible hardware provides comparable performance to the case where vt-d is disabled. The main use case for this change is to decrease the time necessary to copy virtual machine memory during KVM live migration instantiations.
>
> This patch was tested on a system that enables the IOMMU in non-coherent mode. Two DMA remapper issues were encountered and both are in the Intel IOMMU driver with the following patches submitted upstream but not yet commited.
>
> Patch 1 - DMAR:[fault reason 02] Present bit in context entry is clear
> https://lkml.org/lkml/2012/6/15/20

My apologies for posting a truncated link for the above. The correct link is https://lkml.org/lkml/2012/6/15/204

-Craig

