Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2FZHIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:08:38 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58652 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2FZHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:08:36 -0400
Message-ID: <4FE95FE8.3060406@linux.vnet.ibm.com>
Date: Tue, 26 Jun 2012 15:08:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in atomic
 context
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE36D32.3030408@linux.vnet.ibm.com> <20120623030052.GA18440@kroah.com> <4FE86C1D.2020302@linux.vnet.ibm.com> <20120625141145.GA32567@kroah.com>
In-Reply-To: <20120625141145.GA32567@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062607-2674-0000-0000-000005065524
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 10:11 PM, Greg Kroah-Hartman wrote:

> On Mon, Jun 25, 2012 at 08:48:13AM -0500, Seth Jennings wrote:
>> On 06/22/2012 10:00 PM, Greg Kroah-Hartman wrote:
>>> On Thu, Jun 21, 2012 at 01:51:30PM -0500, Seth Jennings wrote:
>>>> I just noticed you sent this patchset to Andrew, but the
>>>> staging tree is maintained by Greg.  You're going to want to
>>>> send these patches to him.
>>>>
>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> After this series is redone, right?  As it is, this submission didn't
>>> look ok, so I'm hoping a second round is forthcoming...
>>
>> Yes. That is the cleanest way since there are dependencies
>> among the patches.  You could pull 04-08 and be ok, but you
>> might just prefer a repost.
> 
> I do prefer a repost, thanks.


Sorry for the delay reply since i was on my vacation. I will
post the v2 soon. Thank you all!

