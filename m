Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab1CDF3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 00:29:47 -0500
Received: from deadhat.com ([71.245.97.202]:50364 "EHLO deadhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1CDF3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 00:29:46 -0500
Message-ID: <4D7078C8.8050009@deadhat.com>
Date: Thu, 03 Mar 2011 21:29:44 -0800
From: David Johnston <dj@deadhat.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, tytso@mit.edu,
        richard.weinberger@gmail.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: Why is my copyright code in the linux kernel?
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com> <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com> <20110301235433.GD2959@thunk.org> <4D6EBC04.5050709@zytor.com>
In-Reply-To: <4D6EBC04.5050709@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/2011 1:52 PM, H. Peter Anvin wrote:
> On 03/01/2011 03:54 PM, Ted Ts'o wrote:
>> On Wed, Mar 02, 2011 at 12:30:45AM +0100, richard -rw- weinberger wrote:
>>>> You will see a remarkable resemblance to parts of
>>>> linux-2.6.36.2/drivers/staging/rt2860/common/cmm_aes.c. E.G. the AES code,
>>> please note, this is a staging driver.
>> It's not even the primary driver.  Is there anything that this driver
>> provides that isn't provided by the upstream supported, mainline
>> rt2x00 project?  I.e., can we just delete the staging driver?
>>
>> If we are going to keep the staging driver for some reason, one of the
>> things that should be added to the TODO list would be delete its
>> driver-specific AES code and replace it with calls to the kernel's
>> generic AES code, which among other things, has the advantage that it
>> can take advantage of the AES-NI instructions provided on more modern
>> x86 CPU's.
>>
>>>> I'd like to know who is an appropriate person to discuss this with.
>>> the code is from ralink.
>> David, you might want to contact ralink directly, since it's likely
>> they are distributing that driver with your AES code in other places
>> besides just in the mainstream kernel sources.  Even if we delete the
>> code in the staging tree, they might be distributing that driver still
>> via other means.
>>
> I think it's more fundamental than that.  If ralink -- or anyone else --
> submitted a plagiarized driver to the staging tree, we should remove it
> immediately unless the copyright holder (David in this case) is willing
> to allow us to retain it while things are sorted out.
>
> And yes, David still needs to contact ralink about sorting out the
> violation.
>
> Finally, obviously, a proper Linux driver should use the AES facilities
> in the kernel crypto core.
>
> 	-hpa
Yes I am willing to allow you to retain it.
I guess, to be all legalese..
     I herein permit you to use any 802.11 related C code taken from the 
www.deadhat.com website, in the linux kernel, and to publish it under 
the terms of version 2 of the GNU General Public License.

Yes I've emailed ralink and VIA. I hope they're nice people.

DJ



