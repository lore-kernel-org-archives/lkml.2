Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2KMRwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:52:21 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49260 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2KMRwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:52:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121113173353.GA878@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1211130845270.15877@pobox.suse.cz>
	<20121113173353.GA878@polaris.bitmath.org>
Date: Tue, 13 Nov 2012 18:52:18 +0100
Message-ID: <CAN+gG=HRabzaOBprZxTQEAu_7mvavdf6YEC=f5LKSn7hgNm0xQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] Win 8 support for digitizers
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, Nov 13, 2012 at 6:33 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> > here is the third version of this patchset.
>> > I think I included most of Henrik's comments.
>> >
>> > Happy reviewing :)
>
> thanks for the changes :-)

and thanks for the review.

>
> Jiri,
>
>> I am fine with the HID-specific changes (and I have sent out my Acks to
>> the invidivual patches).
>
> Looks reasonable to me too (although I have not looked through the exponent
> code enough to want to formally ack it).
>
>> For hid-multitouch changes, I'd like to have Reviewed-by: from Henrik as
>> well. Henrik, are you planning to review this patchset, please?
>
> Yes, and finally done.
>
> Cheers,
> Henrik

Jiri,

I'll send a new patchset tomorrow with the different acked, reviewed
and requested changes.

Some patches at the end may need an other review, so I'll make sure to
get the reviewed patches at the beginning of the set so that you can
pick them for 3.8.
It will also allow me not to send dozens of patches in a row :)

Is it good for you?

Cheers,
Benjamin
