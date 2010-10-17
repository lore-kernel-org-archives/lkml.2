Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0JQPld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:41:33 -0400
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:56512 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757117Ab0JQPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:41:32 -0400
Message-ID: <4CBB191A.4080909@panasas.com>
Date: Sun, 17 Oct 2010 17:41:14 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] exofs: use iput() for inode reference count decrements
References: <1286515292-15882-1-git-send-email-david@fromorbit.com> <1286515292-15882-8-git-send-email-david@fromorbit.com> <20101016075650.GM19147@amd> <20101016162904.GB20086@infradead.org>
In-Reply-To: <20101016162904.GB20086@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2010 15:41:16.0442 (UTC) FILETIME=[BC64E7A0:01CB6E11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2010 06:29 PM, Christoph Hellwig wrote:
> On Sat, Oct 16, 2010 at 06:56:50PM +1100, Nick Piggin wrote:
>> On Fri, Oct 08, 2010 at 04:21:21PM +1100, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Direct modification of the inode reference count is a no-no. Convert
>>> the exofs decrements to call iput() instead of acting directly on
>>> i_count.
>>
>> Could this go to exofs maintainer and get merged as a bugfix?
> 
> I already pinged Boaz.
> 

Thanks guys

It'll be in linux-next in a few minutes, for 2.6.37 merge window.

I'm also testing if it could be removed all together. If I find
that it is needed, after all, I'll also CC stable@.

Boaz
