Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab0KATgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:36:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64104 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0KATgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hAw8hYxLsBYCC/0bhacgkIEkl1teiiHt2C56zHMs9vNWzz3XMIH2QTY9BmXMpWlBpD
         8n8pboWA9O5zAhU5MT3cEI//NOkf9Kh3R9+1cbPP+ncS/WCfAFNTi4jRaJ6IdhcFQXFx
         vbDWOfklpmWBvqOPlEmzWuF7mOV+rL5qzN+OE=
MIME-Version: 1.0
In-Reply-To: <201011020832.16057.manningc2@actrix.gen.nz>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<201011020814.35902.manningc2@actrix.gen.nz>
	<4CCF13FA.1080609@caviumnetworks.com>
	<201011020832.16057.manningc2@actrix.gen.nz>
Date: Mon, 1 Nov 2010 15:36:13 -0400
Message-ID: <AANLkTi=XmuhYoiJNGATDEtGyxj7FWH2UCN8QgqcRmEN6@mail.gmail.com>
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
From: Tracey Dent <tdent48227@gmail.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: David Daney <ddaney@caviumnetworks.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/10, Charles Manning <manningc2@actrix.gen.nz> wrote:
> On Tuesday 02 November 2010 08:24:42 David Daney wrote:
>> On 11/01/2010 12:14 PM, Charles Manning wrote:
>> > On Tuesday 02 November 2010 07:55:39 David Daney wrote:
>> >> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>> >>> The patch sets puts the yaffs2 filesystem in the staging directory.
>> >>> It is all based on Charles git
>> >>> tree(http://github.com/cdhmanning/linux-yaffs-integration/).
>> >>> Everything
>> >>> is compile tested and it builds.
>> >>>
>> >>> This only the inital support and I will be sending more cleanup
>> >>> patches.
>> >>>
>> >>> Greg can you add the patch set into your staging-next tree.
>> >>> Also, It doesn't affect anything other than itself.
>> >>>
>> >>> Thanks,
>> >>>
>> >>> Tracey Dent
>> >>
>> >> I am confused.
>> >>
>> >> Are you and Charles Manning working together on this?
>> >>
>> >> Did you write all this code or did Charles?  If it was Charles, why are
>> >> there no From: and Signed-off-by headers for him?
>> >>
>> >> Thanks in advance for enlightening us as to what is going on here,
>> >> David Daney
>> >
>> > We are not working together on this, but I do appreciate the effort in
>> > helping bring to a head what people like/dislike.
>> >
>> > I am trying to keep the kernel yaffs consistent with the yaffs.net yaffs
>> > so that it is easier to add changes from yaffs.net.
>>
>> Great.  Thanks for clearing things up.
>>
>> I will offer my unsolicited opinion:
>>
>> Charles has obviously expended great effort on yaffs2.  He has a git
>> repository hosting the code, and has expressed a desire to get the code
>> fit for merging.  For Tracey Dent to come along and hijack the entire
>> effort, would anger me if I were in Charles' place.
>
> I don't see any malicious intent from Tracey, but I do wish to see some
> recognition for 8+ years of effort :-).
>

I can resend it with your signed-off-by line instead of mine.

>> Having used yaffs2 in the past, I would like to see the code in the
>> kernel.  Having it come via Charles would seem to make sense.
>>
>
> A prime consideration from me is to try keep the kernel and yaffs.net
> versions
> of yaffs very close to consistent. That will allow me to continue to use my
> existing out-of-kernel dev tools and have other benefits.
>
Like I said its exactly from the git
tree(http://github.com/cdhmanning/linux-yaffs-integration/). It should
still be compatible with all the existing tools.

>
> -- CHarles
>
>


Tracey Dent
