Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab2J2SLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:11:01 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38525 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2J2SK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:10:58 -0400
Message-ID: <508EC69F.2030505@ahsoftware.de>
Date: Mon, 29 Oct 2012 19:10:39 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED
 regions..."
References: <508E58FD.2000707@ahsoftware.de> <508E8264.8070807@ahsoftware.de> <20121029165946.GB6614@kroah.com>
In-Reply-To: <20121029165946.GB6614@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.10.2012 17:59, schrieb Greg Kroah-Hartman:
> On Mon, Oct 29, 2012 at 02:19:32PM +0100, Alexander Holler wrote:
>> Am 29.10.2012 11:22, schrieb Alexander Holler:
>>> Hello,
>>>
>>> I've just bisected a problem with 3.6.4.
>>>
>>> I had to revert commit 54ce8ce298f382a06186cb4672ad6aa090b050b6
>>> (1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a in mainline), otherwise my box
>>> didn't boot.
>>>
>>> I can't provide any output, because I don't see if that commit is
>>> applied. ;)
>>
>> That sentence missed an 'any'. But I've now attached a serial, here is
>> the output:
>
> Thanks for this, it should be fixed in the next 3.6.y release, we needed
> to add two more commits from upstream:
> 	844ab6f993b1d32eb40512503d35ff6ad0c57030
> 	f82f64dd9f485e13f29f369772d4a0e868e5633a
> If you apply those two, and it doesn't solve the problem for you, please
> let us know.

They don't applied cleanly, but after fixing the conflicts it seem's to 
work.

Of course, I don't know the difference with applying those two commits 
or reverting the commit in 3.6.4, but I assume it's better to add the 
two instead of reverting the one (I'm currently to lazy to read and 
understand the commit-messages). ;)

Thanks,

Alexander

