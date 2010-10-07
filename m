Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844Ab0JGBkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:40:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759756Ab0JGBkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:40:35 -0400
Message-ID: <4CAD24C3.9030704@cn.fujitsu.com>
Date: Thu, 07 Oct 2010 09:39:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Dave Airlie <airlied@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: btrfs oops on dodgy SSD
References: <AANLkTiknCR6Z2=L9FoA8+m7o8dw6=Hq1QHWKn7Oyf9UF@mail.gmail.com> <20101006151526.GP9759@think>
In-Reply-To: <20101006151526.GP9759@think>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Wed, Oct 06, 2010 at 11:07:10AM +1000, Dave Airlie wrote:
>> I have an SSD which I use for scratch builds and stuff, it seems to be
>> broken or just dislike my NV sata controller.
>>
>> Was just running Linus tree and got the attached oops when doing a
>> kernel build on it this morning.
>>
>> oops didn't come out in logs, though there were some disk reset and a
>> hung task detect.
>>
>> Might help btrfs robustness maybe if we could avoid the panic ;-)
> 
> Ouch, the oops was in the code printing a corrupted btree block.  I
> should be able to easily trigger this at home...
> 

This reminded me that weeks ago I found a bug in tree-printing code,
though unrelated to this oops.

