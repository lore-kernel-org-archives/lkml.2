Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1HVKnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:43:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47601 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1HVKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110822101655.GF24151@htj.dyndns.org>
References: <CAL7bfHgeQ72uC_7TRmrwz+2d=CsqN2tMKDXfA0oig0ORqka8Fw@mail.gmail.com>
	<20110822101655.GF24151@htj.dyndns.org>
Date: Mon, 22 Aug 2011 15:43:42 +0500
Message-ID: <CAL7bfHgzNj5z0w8rOYWqrKw71gQecNOmdFhyjsswz3J09VmKWw@mail.gmail.com>
Subject: Re: Flashcache, Block cache Linux kernel module
From: Ali Erturk TURKER <turkerali@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 2011-08-22, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Can you please cc linux-kernel@vger.kernel.org when replying?
>
> On Sun, Aug 21, 2011 at 08:15:21PM +0500, Ali Erturk TURKER wrote:
>> I don't want to take your time so let me tell you my kind request. As
>> you may know, there is 3rd party
>> linux kernel module called "Flashcache"
>> (https://github.com/facebook/flashcache) which is used by facebook
>> for block level caching of data on mechanical disks using SSD drives
>> to speed up mysql performance. This
>> module is licensed GNU GPLV2
>> (https://github.com/facebook/flashcache/blob/master/LICENSE) but
>> lives outside the Linus' tree, therefore distros do not ship this
>> module. I believe this feature is very valuable to
>> many users like me, is there a way to merge it to the mainline?
>
> Hmmm... mainlining stuff takes work and I don't think anyone has
> pushed flashcache for mainline inclusion yet.  Also, bcache seems more
> complete and focused on mainlining, so I think that one is more likely
> to make it to mainline.  Have no idea when that would happen tho.
>
> Thanks.
>
> --
> tejun
>

It doesn't matter whether it is a white or black cat as long as it
cathes mice :-)

I've mentioned flashcache since it has proven itself (since facebook
uses it), but you are the boss here. Hope one of them becomes
available soon and we'll enjoy the party.

Regards,
Ali Erturk TURKER
