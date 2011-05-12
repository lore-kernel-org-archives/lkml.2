Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1ELDYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 23:24:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45705 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1ELDYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 23:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dqon9KbteA7xcdh6nIG4UZFaAJj5CdsTGb4p7mGRQIis9EUP7kHV3iKxZJGbVcS2vE
         MXjpkEieroYsBATZ/dKfoyJynLOG0vkWcoP1yG7+bNmbiCTaOEEVrPlhnZSCb37gkNpp
         nIkAvdln2wQBREs6PConUu7fEhNZf3kUerKro=
MIME-Version: 1.0
In-Reply-To: <20110511231843.GC7362@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
	<20110511211401.GC4893@kroah.com>
	<BANLkTikjf9ZAthr3jTUkoUKGJt2UGS73Cg@mail.gmail.com>
	<20110511231843.GC7362@kroah.com>
Date: Wed, 11 May 2011 20:24:12 -0700
Message-ID: <BANLkTim_WZdmE31qjChg8u0M8RKzez3fqg@mail.gmail.com>
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 4:18 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, May 11, 2011 at 04:08:07PM -0700, matt mooney wrote:
>> On Wed, May 11, 2011 at 2:14 PM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, May 11, 2011 at 01:54:12AM -0700, matt mooney wrote:
>> >> Hi Greg,
>> >>
>> >> I am interested in hearing your thoughts on the userspace interface?
>> >
>> > Which one?  The user/kernel interface?
>>
>> Yes.
>>
>> >
>> >> Even as is, it definitely needs some work. For one thing I was thinking
>> >> of removing the debug flag from userspace. The userspace utilites are
>> >> not using it anyway, and it is not 100% working yet.
>> >
>> > I haven't looked at the interface much yet, what is your issue with the
>> > debug flag?
>>
>> I guess it just added a lot of code (most was actually eliminated in
>> the pr_*() change), is not complete, and is inconsistently used. But I
>> see that it would be helpful especially due to the amount of debug
>> messages printed by default. So ignore that complaint.
>
> Ok.
>
>> > To make things easier, and allow you to be able to change the userspace
>> > interface, I suggest moving the userspace code into the kernel tree, and
>> > building it here.  That would allow you to move forward with changing
>> > things easier, doing it all in one place allows you to keep stuff in
>> > sync, and provides people an easier way to actually get the needed tools
>> > to drive the code.
>> >
>> > What do you think about doing that?
>>
>> Sure, I didn't even know that was an option. How do you propose that
>> is done though?
>
> We add it to drivers/staging/usbip/userspace/ and build it like the perf
> code is built.

Okay, I will add the code as is to userspace/ except for the module
name changes of course. Now I am suppose to add this to
scripts/packages/Makefile or is there another way for staging?

Thanks,
matt

>> > I've applied a number of these patches, care to respin the others and
>> > resend them based on my latest tree?
>>
>> Okay, I will do that. I noticed some were missed but that may be
>> because they depended on a few of the unapplied ones anyway, so I will
>> also resend those as well.
>
> Yes, they couldn't be applied so I didn't.
>
> thanks,
>
> greg k-h
>

-- 
GPG-Key: 9AFE00EA
