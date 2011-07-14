Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1GNSDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 14:03:15 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:35746 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab1GNSDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 14:03:14 -0400
Message-ID: <4E1F2F5D.8060505@gmail.com>
Date: Thu, 14 Jul 2011 20:03:09 +0200
From: Peter Klotz <peter.klotz99@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Guus Sliepen <Guus.Sliepen@astro.su.se>, Nick Piggin <npiggin@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
References: <20090105064838.GA5209@wotan.suse.de> <20110714112324.GM30145@sliepen.org>
In-Reply-To: <20110714112324.GM30145@sliepen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 01:23 PM, Guus Sliepen wrote:

> I'm having a problem with a system having an XFS filesystem on RAID locking up
> fairly consistently when writing large amounts of data to it, with several
> kernels, including 2.6.38.2 and 2.6.39.3, on both AMD and Intel multi-core
> processors. The kernel always logs this several times:
>
> BUG: soft lockup - CPU#2 stuck for 67s! [kswapd0:33]
...
>> I believe this patch should solve it. Please test and confirm before
>> I send it upstream.
>
> Further comments on that thread in 2009 indicated the patch was very useful,
> but it doesn't seem to have been applied upstream. Is there any reason this
> patch should not be applied?

Hello Guus

This Bugzilla entry documents the XFS bug from 2009 in detail including 
links:

http://oss.sgi.com/bugzilla/show_bug.cgi?id=805

The problem was finally solved by a patch proposed by Linus. This is the 
reason the original patch developed by Nick never made it into the kernel.

My tests back then showed that both patches fixed the problem.

It seems you have found a test case where just Nick's patch helps.

Regards, Peter.
