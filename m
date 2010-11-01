Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab0KATXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:23:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49811 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0KATXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K7dNfBrvUWL2hkwldj9RwyFpPup6rWaTS1hBQH+IwAdRLZhTSIZo6CvR4psZIaEkNp
         dYgZz32EKXx7zHDlq4UcYB9MXcVFuzmNa/A3PF+uS6jNvK500Y1k22UsXQMR4kc8l/fy
         YIHTUDnab/pT3FfTNDTRMzETTA7a8OHvAoLX8=
MIME-Version: 1.0
In-Reply-To: <201011020814.35902.manningc2@actrix.gen.nz>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<4CCF0D2B.6070308@caviumnetworks.com>
	<201011020814.35902.manningc2@actrix.gen.nz>
Date: Mon, 1 Nov 2010 15:23:29 -0400
Message-ID: <AANLkTi=EU0X3RY9vB7fKbvgWEQ+FspNn=iSwctsKrZtQ@mail.gmail.com>
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
> On Tuesday 02 November 2010 07:55:39 David Daney wrote:
>> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>> > The patch sets puts the yaffs2 filesystem in the staging directory.
>> > It is all based on Charles git
>> > tree(http://github.com/cdhmanning/linux-yaffs-integration/). Everything
>> > is compile tested and it builds.
>> >
>> > This only the inital support and I will be sending more cleanup patches.
>> >
>> > Greg can you add the patch set into your staging-next tree.
>> > Also, It doesn't affect anything other than itself.
>> >
>> > Thanks,
>> >
>> > Tracey Dent
>>
>> I am confused.
>>
>> Are you and Charles Manning working together on this?
>>
>> Did you write all this code or did Charles?  If it was Charles, why are
>> there no From: and Signed-off-by headers for him?

Yeah I forgot to change that. By adding a signed off line by him.

>>
>> Thanks in advance for enlightening us as to what is going on here,
>> David Daney
>
> We are not working together on this, but I do appreciate the effort in
> helping
> bring to a head what people like/dislike.
>
> I am trying to keep the kernel yaffs consistent with the yaffs.net yaffs so
> that it is easier to add changes from yaffs.net.

All I did was take your tree and put it in patch form. So nothing
should change, except I added a general *TODO file.

So you can ack this and get it in Greg'ss Staging-next tree, if you want?
>
> -- Charles
>
>

Regards,

Tracey Dent
