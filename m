Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab0CXEHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:07:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:51405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0CXEHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:07:52 -0400
Message-ID: <4BA98FA8.1040600@kernel.org>
Date: Tue, 23 Mar 2010 21:06:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com> <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com> <20100323113551.GA3862@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20100323113551.GA3862@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 04:35 AM, Stanislaw Gruszka wrote:
> On Sat, Mar 20, 2010 at 11:26:06AM -0700, Yinghai Lu wrote:
>>> After update to 2.6.34-rc1, I was experimented by strange oopses during
>>> boot, what looked like memory corruption. Bisection shows that first bad
>>> commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
>>> support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
>>> system. Not sure what info is need to track down this issue, so please
>>> let me know.
>>
>> can you check patch
>>
>> https://patchwork.kernel.org/patch/87081/
> 
> Patch helps somehow. Instead of many random oopses, now I have one and
> the same oops, here is photo:
> http://people.redhat.com/sgruszka/20100322_001.jpg

how does e820 look like?

YH
