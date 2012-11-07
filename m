Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2KGSwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:52:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53210 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2KGSwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:52:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121023184555.GA3597@kroah.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
	<20121022203405.GA4395@kroah.com>
	<CANBXnMkt-yFe6TRmbrMKdzxi0oUGB8233nF-5-376Ld+P+3CGA@mail.gmail.com>
	<20121023184555.GA3597@kroah.com>
Date: Thu, 8 Nov 2012 00:22:04 +0530
Message-ID: <CANBXnMmQP4kAdHb-MYfcaoctJ1F=RkPnT_ger+Acco2CJDnKRw@mail.gmail.com>
Subject: Re: [PATCH 0/9] Staging: winbond: Fixed coding style issues
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, pavel@ucw.cz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 24, 2012 at 12:15 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 23, 2012 at 03:41:08PM +0530, Adil Mujeeb wrote:
>> On Tue, Oct 23, 2012 at 2:04 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Oct 12, 2012 at 10:07:06PM +0530, Adil Mujeeb wrote:
>> >>
>> >> winbond directory files have lots of coding style issues. The patch set tries to remove *most* (if not all) of the coding style issues. checkpatch.pl script is still complaining (like 80 characters limit) but major part of the serious coding style issues have been rectified.
>> >
>> > None of your patches can be applied due to the wrong patch level they
>> > were generated at.  Please redo them, drop the two offending patches,
>> > and resend the whole series.
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>> Thanks Greg. I will recreate the patches and shall drop the mentioned
>> ones. But I am still not able find where I am doing wrong in
>> generating the patches. I am following your tutorial :) but may be
>> missing something. Please help. I am doing in the following ways:
>>
>> 1. I am downloading the latest rc source archive from ftp.kernel.org
>> under directory /pub/linux/kernel/v3.x/testing
>> 2. Then creating my own git repository treating the base source as master.
>
> Why not just use the kernel git tree?  You will have to work off of
> linux-next if you want to send staging patches, you can not keep up with
> development otherwise.

Thanks Gree for your suggestion. I am using now linux-next tree.
Interestingly some of my patches already submitted by now :)

>
>> 3. Creating a branch from it and tries to fix some sources.
>> 4. Create the patch through git format-patch
>> 5. Submit the patch through git send-email command.
>>
>> Dry run works fine with my repository. Could you please help?
>
> Your patches could not be applied with "patch -p1" from the root of the
> kernel source tree, I think you created your git repo one directory too
> deep.

Thanks for correcting me. I have realized my mistake. I have submitted
fresh patches.

Thanks,
Adil

>
> greg k-h
