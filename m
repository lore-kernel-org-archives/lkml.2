Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0FBWyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:54:52 -0400
Received: from earth.cora.nwra.com ([65.44.101.180]:58552 "EHLO
	earth.cora.nwra.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab0FBWyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:54:51 -0400
Message-ID: <4C06E125.1090201@cora.nwra.com>
Date: Wed, 02 Jun 2010 16:54:29 -0600
From: Orion Poplawski <orion@cora.nwra.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org> <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com> <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
In-Reply-To: <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:31 AM, Alexander Graf wrote:
>
> On 26.05.2010, at 19:10, Orion Poplawski wrote:
>
>> On 05/25/2010 12:21 AM, Gleb Natapov wrote:
>>> Adding kvm to CC.
>>>
>>> On Mon, May 24, 2010 at 04:06:32PM +0000, Orion Poplawski wrote:
>>>> I have a KVM virtual machine running 2.6.33.4-95.fc13.x86_64 on a CentOS 5.5
>>>> host whose clock jumps about 8-12 hours a couple times a day.  I have no idea
>>>> what is causing it.  Fedora 12 and Centos 5.5 KVM machines run fine on the same
>>>> host.  Is there any debugging I can enable to see what is jumping the clock?
>>>>
>>>> kvm-clock: cpu 0, msr 0:1ba4741, boot clock
>>>> kvm-clock: cpu 0, msr 0:1e15741, primary cpu clock
>>>> Switching to clocksource kvm-clock
>>>> rtc_cmos 00:01: setting system clock to 2010-05-20 16:59:48 UTC (1274374788)
>>
>>
>> Thanks, though I don't think it made it there.  I'm also not sure it's completely limited to KVM, though that is the only running system I am currently seeing the problem on.  I also see clock jumps during anaconda installs on physical hardware and apparently they have been present since at least F11.  Might be unrelated though.
>>
>> I'm really at a loss of how to debug this though.
>
> Do you have ntpd running inside the guest? I have a bug report lying around about 2.6.33 with kvm-clock jumping in time when ntpd is used: https://bugzilla.novell.com/show_bug.cgi?id=582260
>
> Alex
>

Turning off ntpd and chronyd did not help for me.


-- 
Orion Poplawski
Technical Manager                     303-415-9701 x222
NWRA/CoRA Division                    FAX: 303-415-9702
3380 Mitchell Lane                  orion@cora.nwra.com
Boulder, CO 80301              http://www.cora.nwra.com
