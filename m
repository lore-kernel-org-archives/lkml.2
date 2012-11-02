Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2KBWUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:20:23 -0400
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:41816 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2KBWUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:20:20 -0400
Message-ID: <509446FB.5000504@genband.com>
Date: Fri, 02 Nov 2012 16:19:39 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>	<20121101210634.GA19723@srcf.ucam.org>	<20121101213127.5967327f@pyramind.ukuu.org.uk>	<20121101212843.GA20309@srcf.ucam.org>	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>	<20121101213452.GA20564@srcf.ucam.org>	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>	<20121101215752.GA21154@srcf.ucam.org> <87625ogzje.fsf@xmission.com>	<20121102140057.GA4668@srcf.ucam.org> <87liejacix.fsf@xmission.com>
In-Reply-To: <87liejacix.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Nov 2012 22:19:40.0974 (UTC) FILETIME=[272E44E0:01CDB948]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19334.002
X-TM-AS-Result: No--8.744500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 04:03 PM, Eric W. Biederman wrote:
> Matthew Garrett<mjg59@srcf.ucam.org>  writes:
>
>> On Fri, Nov 02, 2012 at 01:49:25AM -0700, Eric W. Biederman wrote:
>>
>>> When the goal is to secure Linux I don't see how any of this helps.
>>> Windows 8 compromises are already available so if we turn most of these
>>> arguments around I am certain clever attackers can go through windows to
>>> run compromised kernel on a linux system, at least as easily as the
>>> reverse.
>>
>> And if any of them are used to attack Linux, we'd expect those versions
>> of Windows to be blacklisted.
>
> I fail to see the logic here.  It is ok to trust Microsofts signing key
> because after I have been p0wned they will blacklist the version of
> windows that has was used to compromise my system?
>
> A key revokation will help me when my system is p0wned how?

It won't help you, it will help everyone else that _hasn't_ been p0wned 
already because the affected software will no longer be able to run on 
their system.

And it will help you because if someone _else_ gets p0wned then your 
system won't be able to run the blacklisted insecure software.

> I don't want my system p0wned in the first place and I don't want to run
> windows.  Why should I trust Microsoft's signing key?

In any case, you don't need to trust Microsoft's signing key...at least 
on x86 hardware you can install your own.  But if you want consumer 
hardware to be able to boot linux out-of-the-box without messing with 
BIOS settings then we need a bootloader that has been signed by Microsoft.

Chris
