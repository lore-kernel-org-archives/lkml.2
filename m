Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab1JaXST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:18:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47807 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932477Ab1JaXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:18:18 -0400
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 19:18:18 EDT
Message-ID: <4EAF28B6.6080802@fb.com>
Date: Mon, 31 Oct 2011 16:01:10 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Pekka Enberg <penberg@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [RFC/PATCH 4/7] x86, mm: Wrap ZONE_DMA32 with CONFIG_ZONE_DMA32
References: <1319811801-1725-1-git-send-email-penberg@kernel.org> <1319811801-1725-4-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1110311551290.22237@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110311551290.22237@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-10-31_05:2011-10-31,2011-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/11 3:52 PM, David Rientjes wrote:
> On Fri, 28 Oct 2011, Pekka Enberg wrote:
>
>> In preparation for unifying 32-bit and 64-bit zone_sizes_init() make sure
>> ZONE_DMA32 is wrapped in CONFIG_ZONE_DMA32.
>>
>> Cc: Tejun Heo<tj@kernel.org>
>> Cc: Yinghai Lu<yinghai@kernel.org>
>> Cc: H. Peter Anvin<hpa@linux.intel.com>
>> Cc: David Rientjes<rientjes@google.com>
>> Signed-off-by: Pekka Enberg<penberg@kernel.org>
>
> Acked-by: David Rientjes<rientjes@google.com>
>
> Adding Arun Sharma to the cc, he was interested in disabling
> CONFIG_ZONE_DMA32 and I believe carries this patch internally (as we do).
>

Yes we do.

Acked-by: Arun Sharma <asharma@fb.com>

