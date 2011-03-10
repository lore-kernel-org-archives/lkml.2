Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1CJMDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 07:03:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55516 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1CJMDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 07:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ErA8r2Mq3ZKh/wOm1cQL+3J0Zjvd2jOnQjoxtodvRe8JRug8qRMkk4XUdueG6a9oaZ
         Yh0CBbCSkFRi+/UF6sPvIKnfvnRRA88E7JuNW688iFfX/yIWSKQ/sYB9g/JgIkVZie92
         O8ZaBNbp8hGJZe9iz7q/e0Zem4uNpcvjZEv70=
MIME-Version: 1.0
In-Reply-To: <20110309212735.GB27747@suse.de>
References: <4D6221B8.9040303@gmail.com>
	<4D6F5473.2070709@gmail.com>
	<4D720469.1010101@gmail.com>
	<AANLkTinyK0G=tfZob4u7XBj7Gna3FbZnLrqswz2oajwn@mail.gmail.com>
	<4D720C0B.1050300@gmail.com>
	<4D77D821.7090003@gmail.com>
	<20110309212735.GB27747@suse.de>
Date: Thu, 10 Mar 2011 13:03:08 +0100
Message-ID: <AANLkTi=S++FwLwaedKE17NRFqh5B7b1MYg9OD55XRVfd@mail.gmail.com>
Subject: Re: [PATCH v3][RESEND] Check for immutable/append flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/9 Greg KH <gregkh@suse.de>:
> On Wed, Mar 09, 2011 at 08:42:25PM +0100, Marco Stornelli wrote:
>> Il 05/03/2011 11:10, Marco Stornelli ha scritto:
>> > From: Marco Stornelli <marco.stornelli@gmail.com>
>> >
>> > In the fallocate path the kernel doesn't check for the immutable/append
>> > flag. It's possible to have a race condition in this scenario: an
>> > application open a file in read/write and it does something, meanwhile
>> > root set the immutable flag on the file, the application at that point
>> > can call fallocate with success. In addition, we don't allow to do any
>> > unreserve operation on an append only file but only the reserve one.
>> >
>> > Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Al, can you apply this patch please? I add Greg in cc, because maybe he
>> could be interested about stable tree.
>
> Please read Documentation/stable_kernel_rules.txt for how to get patches
> into stable kernel releases (hint, emailing me like this is not the way
> to do it...)
>

I'm sorry. It wasn't a request about the add of this patch to the
stable tree, it was only a request for comment about the applicability
of this patch in the stable tree. However thanks for the tip, in case
I'll send the patch to the stable mailing list.

Regards,

Marco
