Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0IWXoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:44:06 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39279 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754759Ab0IWXoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <1285248035.2964.2.camel@mini>
References: <1285244139.22958.16.camel@graviton>
	<1285248035.2964.2.camel@mini>
Date: Thu, 23 Sep 2010 19:44:02 -0400
Message-ID: <AANLkTiksoG-_q3z2AE0+tzBmOqu=04GRxdMghCK9mqBT@mail.gmail.com>
Subject: Re: [PATCH v2] HID: magicmouse: Use hid-input parsing rather than
 bypassing it
From: Michael Poole <mdpoole@troilus.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 9:20 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On Thu, 2010-09-23 at 08:15 -0400, Michael Poole wrote:
>> Let the HID core handle input device setup and HID-compliant reports.
>> This driver then only has to worry about the non-standard reports.
>>
>> Signed-off-by: Michael Poole <mdpoole@troilus.org>
>
> Michael, do you need me to retest the patch? I haven't looked at this
> second version, but if it's pretty much as you describe below and you
> don't need me to test it again, then my ACK still stands.
>
> Thanks,
>
> -- Chase

The behavior will be 100% identical for currently supported devices,
so I don't see any real benefit in you re-testing it.  I just didn't
want to assume (without checking) that your ack was valid for the
revised version.

Michael
