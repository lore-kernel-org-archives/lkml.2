Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0KAUrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:47:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51758 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0KAUrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tTY+mkUGuppJ1ZldCwGck9jZMTkINSqzusisShTGxHzqZ4p6akY9efUUAxLhM2P15G
         imVuFC4vWI6rlwswxRENVGnV6rS+BcPCRENExEveimJzd486xFHIMvONqNr/mZiokX01
         14a2DricUgaYv60iQiQi+9R0t3miydfqVGCdU=
MIME-Version: 1.0
In-Reply-To: <20101101201327.GC2049@kroah.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<201011020814.35902.manningc2@actrix.gen.nz>
	<4CCF13FA.1080609@caviumnetworks.com>
	<201011020832.16057.manningc2@actrix.gen.nz>
	<AANLkTi=XmuhYoiJNGATDEtGyxj7FWH2UCN8QgqcRmEN6@mail.gmail.com>
	<20101101201327.GC2049@kroah.com>
Date: Mon, 1 Nov 2010 16:46:58 -0400
Message-ID: <AANLkTikjBzaYzOmVz33_d8hazteOZoRY4RF_LjxTTVCf@mail.gmail.com>
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
From: Tracey Dent <tdent48227@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>,
        David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/10, Greg KH <greg@kroah.com> wrote:
> On Mon, Nov 01, 2010 at 03:36:13PM -0400, Tracey Dent wrote:
>> On 11/1/10, Charles Manning <manningc2@actrix.gen.nz> wrote:
>> > On Tuesday 02 November 2010 08:24:42 David Daney wrote:
>> >> On 11/01/2010 12:14 PM, Charles Manning wrote:
>> >> > On Tuesday 02 November 2010 07:55:39 David Daney wrote:
>> >> >> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>> >> >>> The patch sets puts the yaffs2 filesystem in the staging directory.
>> >> >>> It is all based on Charles git
>> >> >>> tree(http://github.com/cdhmanning/linux-yaffs-integration/).
>> >> >>> Everything
>> >> >>> is compile tested and it builds.
>> >> >>>
>> >> >>> This only the inital support and I will be sending more cleanup
>> >> >>> patches.
>> >> >>>
>> >> >>> Greg can you add the patch set into your staging-next tree.
>> >> >>> Also, It doesn't affect anything other than itself.
>> >> >>>
>> >> >>> Thanks,
>> >> >>>
>> >> >>> Tracey Dent
>> >> >>
>> >> >> I am confused.
>> >> >>
>> >> >> Are you and Charles Manning working together on this?
>> >> >>
>> >> >> Did you write all this code or did Charles?  If it was Charles, why
>> >> >> are
>> >> >> there no From: and Signed-off-by headers for him?
>> >> >>
>> >> >> Thanks in advance for enlightening us as to what is going on here,
>> >> >> David Daney
>> >> >
>> >> > We are not working together on this, but I do appreciate the effort
>> >> > in
>> >> > helping bring to a head what people like/dislike.
>> >> >
>> >> > I am trying to keep the kernel yaffs consistent with the yaffs.net
>> >> > yaffs
>> >> > so that it is easier to add changes from yaffs.net.
>> >>
>> >> Great.  Thanks for clearing things up.
>> >>
>> >> I will offer my unsolicited opinion:
>> >>
>> >> Charles has obviously expended great effort on yaffs2.  He has a git
>> >> repository hosting the code, and has expressed a desire to get the code
>> >> fit for merging.  For Tracey Dent to come along and hijack the entire
>> >> effort, would anger me if I were in Charles' place.
>> >
>> > I don't see any malicious intent from Tracey, but I do wish to see some
>> > recognition for 8+ years of effort :-).
>> >
>>
>> I can resend it with your signed-off-by line instead of mine.
>
> You need to properly credit _who_ did the code in the first place.  And
> your patches did not do that at all, which is very bad, and rude, and
> something that we care deeply about.
>
> Please read the file, Documentation/SubmittingPatches for how to
> properly attribute the author of the patch when you send it out.
>
> I'm not going to take this as-is because of this problem, and neither
> will any other maintainer.  Someone can resend it with the proper author
> and signed-off-by stuff and I'll be glad to look at it again then.
>

Sorry for not giving credit. I will resend following patch set with
proper credits.

> thanks,
>
> greg k-h

Sorry,

Tracey Dent
