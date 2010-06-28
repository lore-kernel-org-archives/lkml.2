Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0F1NwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:52:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:58661 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753391Ab0F1NwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:52:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAFdGKExLd/sX/2dsb2JhbAAHgxbMU5BSgSmDCXIE
X-IronPort-AV: E=Sophos;i="4.53,497,1272859200"; 
   d="scan'208";a="69026888"
Message-ID: <4C28A8FC.6040605@teksavvy.com>
Date: Mon, 28 Jun 2010 09:51:56 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Brian Bloniarz <bmb@athenacr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com> <4C111685.8010400@athenacr.com> <4C27DA4A.3040708@teksavvy.com> <4C284931.2000908@fusionio.com>
In-Reply-To: <4C284931.2000908@fusionio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 03:03 AM, Jens Axboe wrote:
> On 2010-06-28 01:10, Mark Lord wrote:
>> On 10/06/10 12:44 PM, Brian Bloniarz wrote:
..
>>> https://bugzilla.kernel.org/show_bug.cgi?id=15906 has links to the
>>> downstream bugs.
>> ..
>>
>> Jens, this bug has been biting my servers badly here for the past
>> few months -- umount after a backup (from ext4 to ext4) takes 3-4 minutes
>> instead of the expected 3-4 seconds.
>>
>> Is there a patch file for this against 2.6.34 that I (and others) could use?
>
> It's the patch series from Christoph in my for-linus branch, I intend
> to push it upstream when Linus is back and taking patches.
..

Still looking for a *patch* to fix  this here.

I found these two:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=e913fc825dc685a444cb4c1d0f9d32f372f5986
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=30fd1e551a730d942e91109762c942786be0ef7c

But they don't apply cleanly to 2.6.34.

Anyone?
  

