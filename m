Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2KLK6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:58:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42123 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2KLK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:58:07 -0500
Message-ID: <50A0D636.9060804@gmail.com>
Date: Mon, 12 Nov 2012 20:57:58 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Solda <dso@cypress.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Troy Abercrombia <ta@cypress.com>, Kamal Mostafa <kamal@canonical.com>,
        =?ISO-8859-9?Q?Ozan_=C7a=F0layan?= <ozancag@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        customercare <customercare@cypress.com>,
        "mario_limonciello@dell.com" <mario_limonciello@dell.com>
Subject: Re: Why Cypress does not upstream its trackpad driver?
References: <CAFub=KTf2dWxM9=saG2JaNJpEioJM8rM3UBG9BkyxRN-+j0psQ@mail.gmail.com> <C825ADB6BE8AC2468577BFFCE7DF5B8A1F080FA111@VMBX133.ihostexchange.net> <EE629F2C-DD83-403C-AD73-E9ED966EEA91@cypress.com> <2208882.BvOrfBvj6F@dtor-d630.eng.vmware.com> <C6B11F3154DB7242B32DD96C876EA7847BAFFAFA95@VMBX113.ihostexchange.net>
In-Reply-To: <C6B11F3154DB7242B32DD96C876EA7847BAFFAFA95@VMBX113.ihostexchange.net>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/12 10:26, David Solda wrote:
> Dmitry, all,
>
> To clarify my comment.  Our protocol utilizes 8 bytes which are needed in our driver.  In order for the Linux system to accept 8 bytes of data, the Linux psmouse system driver is required to be modified.  Without this modification, the driver that you are referring to will not work correctly.  The psmouse system driver change that would be required is the item that would be rejected.

In this case, would a solution that involves submitting two separate 
patches be suitable?

For example, an initial patch set to psmouse that allows an arbitrary 
number of bytes be
  (accepted? used?), while keeping a default value to allow the other 
old drivers to keep working,
and then another patch set with the new driver utilizing the first patch 
set?

Sorry if this doesn't make any sense - I've been working with generics 
and abstract class structure
in Java for the last few weeks, and forget what parts are possible in C 
and which parts are not.

Keep up the good work. Even if it's a driver that needs a change, it's 
still an open-source driver! Be happy :)

>
> I appreciate your comments and of course, if the driver could be upstreamed, it would (we already have I2C drivers updstreamed for Chrome systems), but there is a difference here.
>
> I will again look into the possibility of what you are requesting, however, the changes are extremely low if not zero that it will be accepted.
>
> Dave
>
> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, November 07, 2012 4:16 PM
> To: David Solda
> Cc: Troy Abercrombia; Kamal Mostafa; Ozan Çaðlayan; linux-kernel@vger.kernel.org; linux-input@vger.kernel.org; customercare; mario_limonciello@dell.com
> Subject: Re: Why Cypress does not upstream its trackpad driver?
>
> Hi David,
>
> On Wednesday, November 07, 2012 06:30:11 PM David Solda wrote:
>> Kamal,
>>
>> My name is Dave Solda and I would be happy to answer any other
>> questions that you have. Troy's response is correct however as in
>> order to support the default Linux mouse class, our firmware would
>> also have to be modified to do so, which cannot be done in system. Our
>> packet protocol maxes out at an 8 byte packet, which requires a change
>> to the Linux standard in this case.
> I am unable to parse this... I do not believe anyone asks you to change your firmware and if your protocol needs 8 bytes to transmit device state - that's fine.
>
>> Our goal in working with canonical was to provide something on Linux
>> that would support multi-touch and not only have default single finger
>> movement supported.
>> If I am mistaken and he Linux kernel would accept this, then we can
>> proceed to upstream, however all indications we have is that this
>> patch would be rejected.  If you (or others on from the locus alias)
>> have any inputs, I would be happy to receive them.
> This really depends on whether the changes to the psmouse framework make sense or not. Please start submitting patches for review/discussion and we can go from there.
>
> Thanks.
>
> --
> Dmitry
>
> This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

