Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1KWNOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:14:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53339 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1KWNOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1111231348020.28728@pobox.suse.cz>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1111231348020.28728@pobox.suse.cz>
Date: Wed, 23 Nov 2011 14:14:01 +0100
X-Google-Sender-Auth: xwmkoyK1JqklSWeLfvvI4N8tWt4
Message-ID: <CAN+gG=F5-abvwAC9qE7KAkCe-49NsQgqiue++OdNx1Bq4WUOEQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] multitouch updates (mainly eGalax)
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 13:49, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 23 Nov 2011, Benjamin Tissoires wrote:
>
>> Here are some multitouch updates.
>> Jiri, the first one is already in your upstream-fixes branch, but not in
>> your for-next branch...
>
> Hi Benjamin,
>
> yes, that is intentional. 'upstream-fixes' branch is what is scheduled to
> be sent to Linus still during this development cycle (and therefore is not
> for linux-next).
>
> Other branches get merged into linux-next, as they are scheduled for next
> merge window.
>
>> Patch 0002 will help end-users to test their device without recompiling the
>> hid-multitouch between each test.
>>
>> Patches 0003-0008 are focused on eGalax:
>> * I made some cleanup in the #defines for the PIDS.
>> * I removed the MT_QUIRK_EGALAX_XYZ_FIXUP as I understood why it was needed
>> * I also removed the .maxcontact field in EGALAX as it is not necessary
>>   (it was tested on 3 devices: Acer Iconia W500 by Marek, 0xa001 by Cedric,
>>    and Windpad 110W by me)
>> * I added a few new devices (I included the one reported by Marek and I kept
>>   his "From")
>> * I included the new protocol for a001 devices (reported by Cedric)
>
> I will be queueing all those for 3.3, okay?

I'm ok with that.

Thanks a lot,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>
