Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2JRKQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:16:23 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:48768 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2JRKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:16:21 -0400
From: Jian-Jhong Ding <jj_ding@emc.com.tw>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-hid: introduce HID over i2c specification implementation
In-Reply-To: <CAN+gG=HLxXJAwZ8mWzuDFVBht4BeWaSEvXOQZEBgS8akyerQEw@mail.gmail.com>
References: <1350333533-13366-1-git-send-email-benjamin.tissoires@gmail.com> <87zk3kjghz.fsf@emc.com.tw> <CAN+gG=HLxXJAwZ8mWzuDFVBht4BeWaSEvXOQZEBgS8akyerQEw@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 18 Oct 2012 18:16:21 +0800
Message-ID: <87wqyojdai.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Tissoires <benjamin.tissoires@gmail.com> writes:
> Hi JJ,
>
> On Thu, Oct 18, 2012 at 11:07 AM, Jian-Jhong Ding <jj_ding@emc.com.tw> wrote:
>> Hi Benjamin,
>>
>> Some suggestions to make the error messages more "human", and a little
>> question on the return value of i2c_hid_fetch_hid_descriptor.  Please see below:
>
> I fully agree with the more "human" error messages.
>
> However, for i2c_hid_fetch_hid_descriptor return values, I'm affraid I
> can't use -EINVAL.
>
> Jean Delvare (one of the i2c maintainers) told in his review of the v1:
> "
> These should all be -ENODEV in this function
> [i2c_hid_fetch_hid_descriptor]: the device isn't what you
> expected. EINVAL is for invalid argument.
> "

I must have missed that mail.  Thank you for pointing this out.

-JJ

> So ENODEV is the right return value.
>
> Anyway, thanks for the review.
>
> Cheers,
> Benjamin
