Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1HPJvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 05:51:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57618 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1HPJvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 05:51:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1108161145270.27118@pobox.suse.cz>
References: <1313076137-22590-1-git-send-email-nlopezcasad@logitech.com>
	<20110812055552.GB25184@core.coreip.homeip.net>
	<CAH59Y+oMWpjDWB1S6x3J0J+To=1Nv-w6bz+W2BiDyBidWG0kUg@mail.gmail.com>
	<alpine.LNX.2.00.1108161145270.27118@pobox.suse.cz>
Date: Tue, 16 Aug 2011 11:51:02 +0200
Message-ID: <CAN+gG=E-XJ9s+1vhXLG2516JbB5EZSxqFERMcmbnUO_P3AnWgQ@mail.gmail.com>
Subject: Re: [PATCH v2] HID: Add full support for Logitech Unifying receivers
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin_Tissoires@logitech.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtitmuss@logitech.com, ogay@logitech.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Aug 16, 2011 at 11:46, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 13 Aug 2011, Benjamin Tissoires wrote:
>
>> First of all, thank you for this detailed review. Nestor and I agree
>> yesterday on the fact that I'll submit the next version of this patch.
>> He'll be busy for 2 weeks, and I need to work with this driver for other
>> devices we have at Logitech. I'll make the straight forward changes, and
>> when it will require more expertise on the receiver, I'll ask to Nestor.
>
> If you could send first the patch with Dmitry's feedback (thanks Dmitry!)
> incorporated, and support for other devices as a separate patch on top of
> that, that'd be great.
>

That's exactly what we want to do. The corrected patch will come
first, and we'll add features later: I'm currently writing them now
;-)

Cheers,
Benjamin

PS: sorry for the people in the list, my previous reply has not been
accepted by the LKML with my Logitech address.


> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
