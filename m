Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1BJTuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:50:20 -0500
Received: from mail.tpi.com ([70.99.223.143]:2360 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1BJTuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:50:19 -0500
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 14:50:19 EST
Message-ID: <4D543AD6.4000908@canonical.com>
Date: Thu, 10 Feb 2011 12:21:58 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
CC: Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Block IO throttling disabled in distros
References: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF7284B@GVW0432EXB.americas.hpqcorp.net> <20110207160451.GH7437@redhat.com> <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF72FB5@GVW0432EXB.americas.hpqcorp.net>
In-Reply-To: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF72FB5@GVW0432EXB.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 12:24 AM, Haefliger, Juerg wrote:
>> On Mon, Feb 07, 2011 at 03:33:38PM +0000, Haefliger, Juerg wrote:
>>> Hi,
>>>
>>> Both RHEL6 and Ubuntu 10.10 have block IO throttling disabled in
>> their kernels. Does anybody know why that is? Are there performance or
>> stability issues with the throttling controller or does it somehow
>> negatively interfere with the rest of the kernel and/or system?
>>
>> Block IO throttling support was not even upstream at that time hence
>> you don't see it.
>
> Duh! I thought I checked that the code was there but just not enabled. I just double-checked and sure enough block IO throttling is not in the RHEL6 kernel source. Sorry for the noise.
>
> Thanks
> ...Juerg
>
>
>> I have not heard about any stability issues so far. Of course more
>> testing will reveal that.
>>
>> The only thing I have thinking is that should we limit the number of
>> bios queued per IO context on the device. Currently there is no such limit
>> and one can queue up as many bios as one want to.
>>
>>
>> Thanks
>> Vivek
> --

CONFIG_BLK_DEV_THROTTLING=y in what will be Ubuntu 11.04

rtg
-- 
Tim Gardner tim.gardner@canonical.com
