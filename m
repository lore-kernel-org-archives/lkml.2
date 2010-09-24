Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0IXI6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 04:58:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41583 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab0IXI6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 04:58:04 -0400
Message-ID: <4C9C67FF.8040606@kernel.dk>
Date: Fri, 24 Sep 2010 10:57:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org, hch@lst.de
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com> <20100923223530.GA5658@redhat.com>
In-Reply-To: <20100923223530.GA5658@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-24 00:35, Vivek Goyal wrote:
> On Thu, Sep 23, 2010 at 03:54:04PM -0400, Vivek Goyal wrote:
>>
>> Hi,
>>
>> We seem to have deprecated the notion of sharing request queue across gendisks. Now we need to instanciate one request queue per disk.
>>
>> There see to be still some drivers sharing request queue across disks. Arch
>> specific floppy drivers like amiga and atari are doing so.
>>
>> These are two patches which should fix the issue. But these patches are
>> completely untested. Not even compilte tested. Don't have hardware to test
>> them. 
>>
>> Would be great if somebody who has the hardware can lend a hand here to
>> see if these patches work.
> 
> Sending this mail to linux-m68k@lists.linux-m68k.org list, incase somebody
> can help there with testing.

I think for these drivers, the best we can probably due is ensure that it
cross compiles. As Andreas mentions, getting test coverage is hard and
it's not even given that they work as-is right now.

And since getting this done serves the greater higher purpose of getting
rid of some nasty hacks in the core kernel, we can't let some ancient
and bit rotted (and most likely completely unused) drivers stop this.

-- 
Jens Axboe

