Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab2LWFAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 00:00:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49601 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab2LWFAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 00:00:39 -0500
Message-ID: <50D68FDC.6020700@zytor.com>
Date: Sat, 22 Dec 2012 21:00:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 24/27] x86: Add swiotlb force off support
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-25-git-send-email-yinghai@kernel.org> <20121222021813.GC3468@phenom.dumpdata.com> <CAE9FiQVARkz1_kuCF7L9ufaROQ0EyoyrTjJCsmK7JynepXe=Yw@mail.gmail.com>
In-Reply-To: <CAE9FiQVARkz1_kuCF7L9ufaROQ0EyoyrTjJCsmK7JynepXe=Yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 09:00 PM, Yinghai Lu wrote:
> On Fri, Dec 21, 2012 at 6:18 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>> On Thu, Dec 13, 2012 at 02:02:18PM -0800, Yinghai Lu wrote:
>>> So use could disable swiotlb from command line, even swiotlb support
>>> is compiled in.  Just like we have intel_iommu=on and intel_iommu=off.
>>
>> Does this have any usage besides testing?
>
> for kdump.
>

"For kdump" isn't an answer.  There is a reason why kdump needs this.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

