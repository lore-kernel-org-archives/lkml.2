Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab2H0BoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 21:44:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62630 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2H0BoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 21:44:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-LUaRzhUs4AvVUvT4xZkdvGL-9WcJyJQ0S463CyWe+Jow@mail.gmail.com>
References: <1344369495-21943-1-git-send-email-ccross@android.com>
 <20120808011245.GC640@khazad-dum.debian.net> <CAK5ve-L4JJ_HX5+csMbac_PYO=4mR2tVNsP3SGEvTnYYEbg46g@mail.gmail.com>
 <CAK5ve-LUaRzhUs4AvVUvT4xZkdvGL-9WcJyJQ0S463CyWe+Jow@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 27 Aug 2012 09:43:49 +0800
X-Google-Sender-Auth: Rn3ZmCmAd9YOFzHxGMvsf1p6IS8
Message-ID: <CAK5ve-J6c_z3PRHYG--wr5eX-XpDL5omVZVZA3T69Fs2GtasfQ@mail.gmail.com>
Subject: Re: [PATCH v2] leds: triggers: send uevent when changing triggers
To: Colin Cross <ccross@android.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My bad. I apologize to the delay. I missed the v2 original patch email
in this thread, but googled and found it.
Applied to my for-next branch now.

Thanks,
-Bryan

On Tue, Aug 14, 2012 at 7:34 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> On Wed, Aug 8, 2012 at 10:16 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
>> On Wed, Aug 8, 2012 at 9:12 AM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>>> On Tue, 07 Aug 2012, Colin Cross wrote:
>>>> Some triggers create sysfs files when they are enabled.  Send a uevent
>>>> "change" notification whenever the trigger is changed to allow userspace
>>>> processes such as udev to modify permissions on the new files.
>>>>
>>>> A change notification will also be sent during registration of led class
>>>> devices or led triggers if the default trigger of an led class device
>>>> is found.
>>>>
>>>> Signed-off-by: Colin Cross <ccross@android.com>
>>>
>>> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>>>
>>
>> Colin, could you please resend an update patch with some
>> documentations as Henrique pointed out? Then I will add Ack from
>> Henrique and Greg and apply this patch.
>>
>
> Colin, will you update the patch or just keep this one.
>
> -Bryan



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
