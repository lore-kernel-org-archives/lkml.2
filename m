Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2DGUEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:04:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53403 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab2DGUEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:04:41 -0400
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 07 Apr 2012 13:04:13 -0700
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <4c3e598f-35f8-4abd-8c62-4655d33b0750@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even "doing it manually" gets hard because udev gets in the way.

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>On Sat, 07 Apr 2012 11:36:26 -0700
>"H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> Currently, devpts supports a legacy mode where only one instance
>exists.
>>  For backwards compatibility, this is also the default mode, but the
>> right thing should be to migrate everyone over to the "newinstance"
>scheme.
>> 
>> However, it is increasingly clear that that is not happening; neither
>> the distros nor udev support this by default at this point.
>
>Well maybe thats because the legacy mode works perfectly well for most
>purposes and does what they want. The "non-legacy" mode is really not
>"non-legacy" its "special case extra funkiness".
>
>With my tty hat on I'd prefer to keep it indefinitely if need be. It's
>hardly a maintainability issue or a hot problem. We've got much bigger
>turds to juggle than that.
>
>I don't see why we need an agendum to force the users into making
>changes
>that really don't matter. I mean we still support BSD ptys 8)
>
>Alan

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
