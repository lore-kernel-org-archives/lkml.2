Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2LMG1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 01:27:49 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:43694 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LMG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:27:48 -0500
Message-ID: <50C9755D.6060300@ozlabs.ru>
Date: Thu, 13 Dec 2012 17:27:41 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
References: <1354636299.1809.431.camel@bling.home>  <1354865750-8104-1-git-send-email-aik@ozlabs.ru>  <1354901926.3224.96.camel@bling.home> <50C820AF.8050804@ozlabs.ru>  <1355322875.3224.201.camel@bling.home> <1355365763.19932.75.camel@pasglop>
In-Reply-To: <1355365763.19932.75.camel@pasglop>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/12 13:29, Benjamin Herrenschmidt wrote:
> On Wed, 2012-12-12 at 07:34 -0700, Alex Williamson wrote:
>>> But what would I put there?... IOMMU ID is more than enough at the moment
>>> and struct iommu_table does not have anything what would have made sense to
>>> show in the sysfs...
>>
>> I believe David mentioned that PEs had user visible names.  Perhaps they
>> match an enclosure location or something.  Group numbers are rather
>> arbitrary and really have no guarantee of persistence.  Thanks,
>
> I agree. Make up something, for example domain[PE] or something like
> that.

To be able to add a PE number, I need to call iommu_group_alloc() in the 
correct place where I know this number OR I have to carry it in iommu_table 
till the moment the iommu_group_alloc() is called (acceptable but not cool).

I will post a patch which would help as a response to this mail.


-- 
Alexey
