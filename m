Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2HHCRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:17:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37200 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2HHCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120808011245.GC640@khazad-dum.debian.net>
References: <1344369495-21943-1-git-send-email-ccross@android.com> <20120808011245.GC640@khazad-dum.debian.net>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 8 Aug 2012 10:16:38 +0800
X-Google-Sender-Auth: dS3cV1tr3blPQJFTXNTrqzs2-tQ
Message-ID: <CAK5ve-L4JJ_HX5+csMbac_PYO=4mR2tVNsP3SGEvTnYYEbg46g@mail.gmail.com>
Subject: Re: [PATCH v2] leds: triggers: send uevent when changing triggers
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 9:12 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 07 Aug 2012, Colin Cross wrote:
>> Some triggers create sysfs files when they are enabled.  Send a uevent
>> "change" notification whenever the trigger is changed to allow userspace
>> processes such as udev to modify permissions on the new files.
>>
>> A change notification will also be sent during registration of led class
>> devices or led triggers if the default trigger of an led class device
>> is found.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>

Colin, could you please resend an update patch with some
documentations as Henrique pointed out? Then I will add Ack from
Henrique and Greg and apply this patch.

Thanks,
-Bryan
