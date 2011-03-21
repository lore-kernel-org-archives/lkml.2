Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1CUNcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:32:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33639 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1CUNcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SYfVbLGotzugQV0BHWN7CTZZTkKfNmBv6Xg/t001z2TKf6qC+ghtLPMnnYJMXP2bvi
         XjT3+iE7hXw9it7W01m4lM8ESJaNs/GcyI35yKDkeRh9FTB0ki4FQ7f5dunrz7XV2ZSY
         WCcZB4fEKbm6BcliddJqPMemT4HPeCUJg6wes=
MIME-Version: 1.0
In-Reply-To: <20110321090240.GD3784@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
	<1300454876-5017-5-git-send-email-benjamin.tissoires@enac.fr>
	<20110321090240.GD3784@polaris.bitmath.org>
Date: Mon, 21 Mar 2011 14:32:16 +0100
X-Google-Sender-Auth: uuiMknuzsdFVpGhqzS_E3GmGGl4
Message-ID: <AANLkTimx6YR_ByHDeqyMmSuE659xyRNkaAoOffTp_RgC@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] hid-multitouch: refactor initialization of ABS_MT_ORIENTATION
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Mar 21, 2011 at 10:02, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Mar 18, 2011 at 02:27:55PM +0100, Benjamin Tissoires wrote:
>> No semantic changes, it's just easier to read the code.
>
> Please augment this commit message.

How about:

"The way the input_set_abs_params was called for the new composite
field ABS_MT_ORIENTATION was not very clear at second reading.
We can remove the non-necessary call to set_abs and use the simple
call to input_set_abs_params."

Cheers,
Benjamin

>
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> Reviewed-by: Stéphane Chatty <chatty@enac.fr>
>> ---
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
