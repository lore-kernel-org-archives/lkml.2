Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1KWLgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:36:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53453 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1KWLgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:36:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1111231228260.28728@pobox.suse.cz>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
	<1322042074-3759-7-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1111231228260.28728@pobox.suse.cz>
Date: Wed, 23 Nov 2011 12:36:15 +0100
X-Google-Sender-Auth: fzDdyqPIjU3yDJmzzShTZ4DmCXU
Message-ID: <CAN+gG=HUFDxKp7UP8MwvprbKfNTM1Kr14SCphhMw-ZxSMB9z+Q@mail.gmail.com>
Subject: Re: [PATCH 6/8] HID-multitouch: Add egalax ID for Acer Iconia W500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:28, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 23 Nov 2011, Benjamin Tissoires wrote:
>
>> From: Marek Vasut <marek.vasut@gmail.com>
>>
>> This patch adds USB ID for the touchpanel in Acer Iconia W500. The panel
>> supports up to five fingers, therefore the need for a new addition of panel
>> types.
>>
>> originally Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>
> Before taking this, I'd like to have the credits / signoffs for this patch
> clarified.

Sorry for that,

I cherry-picked Marek's patch and do some modifications.
I wanted to keep his "from" as he already sent 2 patches that were
lost in the LKML (mostly because of my fault).

So, in this one, you have at least my Signed-off-by.
Marek, will you just answer to this mail with your signed-off-by?

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
>
