Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1AUVKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:10:08 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33199 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1AUVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:10:03 -0500
MIME-Version: 1.0
X-Originating-IP: [84.96.59.108]
In-Reply-To: <20110121182749.GE2400@joana>
References: <1294138788-10307-1-git-send-email-pavan_savoy@ti.com>
	<AANLkTinPC-i2xi9pCQ-RzGWuwZ5uTM3NXG7y6gwTnPYv@mail.gmail.com>
	<20110121171857.GC2400@joana>
	<AANLkTimGNjfMtf+6XBMfKHo_F0sEnAJVdWjobfxDWoe7@mail.gmail.com>
	<20110121182749.GE2400@joana>
Date: Sat, 22 Jan 2011 02:40:01 +0530
X-Google-Sender-Auth: zaHucjcqrgQs-hstjmcMVfwMUKg
Message-ID: <AANLkTikNYCYN93UsRoL4jD+pNoOjrb70NE77QFOCbAYW@mail.gmail.com>
Subject: Re: [RFC 0/2] remove BT references from TI_ST
From: Pavan Savoy <pavan_savoy@ti.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Pavan Savoy <pavan_savoy@ti.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo,

On Fri, Jan 21, 2011 at 11:57 PM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
> Hi Pavan,
>
> * Pavan Savoy <pavan_savoy@sify.com> [2011-01-21 23:10:28 +0530]:
>
>> >> > If this is alright, I will send out a modified patch with updated
>> >> > subject to lkml/Greg for linux-next.
>> >
>> > Ok. Go ahead. Then tell me when I'll be able to apply your patch. (I need to
>> > have the core modifications in my tree first). Or I just ack the patch and it
>> > finds its way to mainline through Greg's tree.
>>
>> Yes, I will post a patch to lkml against linux-next to greg KH, and
>> based on that send a
>> separate patch to linux-bluetooth for the btwilink..
>
> Actually send everything to Greg KH, will work out better. Otherwise you will
> have to one release cycle to merge it here (until the other patches reach my
> tree). Then I just Ack it.

Thanks, I will do that.
I will fix up the btwilink comments too...
I have few other patches on TI ST lined up as well. (kind of reviewed
by Samuel Ortiz too...).
So I will put them all together and post them within couple of days.

Thanks a lot.


> --
> Gustavo F. Padovan
> http://profusion.mobi
>
