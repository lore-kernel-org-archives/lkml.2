Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2BCKHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:07:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62736 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2BCKHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:07:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202020935390.18918@pobox.suse.cz>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
	<1326887468-5148-2-git-send-email-benjamin.tissoires@enac.fr>
	<20120120160948.GA18530@polaris.bitmath.org>
	<20120120164849.GA6520@core.coreip.homeip.net>
	<CAN+gG=HsiGyCMVHbWm1ri5q5_s8L0Af76B9R8gJVHhKMa8t1FQ@mail.gmail.com>
	<alpine.LNX.2.00.1202020935390.18918@pobox.suse.cz>
Date: Fri, 3 Feb 2012 11:07:34 +0100
X-Google-Sender-Auth: XrMY3-xFdXPCDC-NBYlg9h70zQY
Message-ID: <CAN+gG=Fv-uO03UvyCjX2_cUHWcTo5kqqLWw6sTZm8C=gCUXyyA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hid-multitouch: add support for trackpads
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, Feb 2, 2012 at 09:36, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 24 Jan 2012, Benjamin Tissoires wrote:
>
>> Hi Dmitry and Henrik,
>>
>> Thanks Dmitry for the comment.
>>
>> I'll do the change as you mentioned and will also remove the
>> input_mt_report_finger_count call.
>
> Benjamin,
>
> I have just materialized from almost 3 weeks of being offline, so I just
> wanted to check the current status of this.

no problems on my side (was quite busy)

>
> Are you planning to send v3 of this patchset?

sure. I'll try to do it today.

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
