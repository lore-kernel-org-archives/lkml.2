Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab1CBVwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:52:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48175 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593Ab1CBVwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:52:15 -0500
Message-ID: <4D6EBC04.5050709@zytor.com>
Date: Wed, 02 Mar 2011 13:52:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>, dj@deadhat.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Why is my copyright code in the linux kernel?
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com> <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com> <20110301235433.GD2959@thunk.org>
In-Reply-To: <20110301235433.GD2959@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 03:54 PM, Ted Ts'o wrote:
> On Wed, Mar 02, 2011 at 12:30:45AM +0100, richard -rw- weinberger wrote:
>>> You will see a remarkable resemblance to parts of
>>> linux-2.6.36.2/drivers/staging/rt2860/common/cmm_aes.c. E.G. the AES code,
>>
>> please note, this is a staging driver.
> 
> It's not even the primary driver.  Is there anything that this driver
> provides that isn't provided by the upstream supported, mainline
> rt2x00 project?  I.e., can we just delete the staging driver?
> 
> If we are going to keep the staging driver for some reason, one of the
> things that should be added to the TODO list would be delete its
> driver-specific AES code and replace it with calls to the kernel's
> generic AES code, which among other things, has the advantage that it
> can take advantage of the AES-NI instructions provided on more modern
> x86 CPU's.
> 
>>> I'd like to know who is an appropriate person to discuss this with.
>>
>> the code is from ralink.
> 
> David, you might want to contact ralink directly, since it's likely
> they are distributing that driver with your AES code in other places
> besides just in the mainstream kernel sources.  Even if we delete the
> code in the staging tree, they might be distributing that driver still
> via other means.
> 

I think it's more fundamental than that.  If ralink -- or anyone else --
submitted a plagiarized driver to the staging tree, we should remove it
immediately unless the copyright holder (David in this case) is willing
to allow us to retain it while things are sorted out.

And yes, David still needs to contact ralink about sorting out the
violation.

Finally, obviously, a proper Linux driver should use the AES facilities
in the kernel crypto core.

	-hpa
