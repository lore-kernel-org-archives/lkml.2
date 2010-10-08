Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0JHQey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:34:54 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16654 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab0JHQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:34:52 -0400
Message-ID: <4CAF47F3.3070800@caviumnetworks.com>
Date: Fri, 08 Oct 2010 09:33:55 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.36-rc7
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <20101007190741.2dc62626@lxorguk.ukuu.org.uk> <1286473768.2656.21.camel@dhcp231-98.rdu.redhat.com> <201010081406.10190.agruen@suse.de>
In-Reply-To: <201010081406.10190.agruen@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2010 16:34:05.0697 (UTC) FILETIME=[9FB31710:01CB6706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 05:06 AM, Andreas Gruenbacher wrote:
> On Thursday 07 October 2010 19:49:28 Eric Paris wrote:
>> The safest thing would probably be to punt the syscalls to 2.6.37.
>> Which is sad since I know a number of people are already working against
>> them, but maybe that proves it's the best approach?
>
> I agree with removing the syscalls from 2.6.36 because of the following
> reasons:

How would the mechanics of this be achieved?

Is it enough to just unconditionally return -ENOSYS from the sys_*() 
functions?  Or should all the patches be reverted?

David Daney


