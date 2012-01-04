Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2ADDuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 22:50:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60384 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2ADDuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 22:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <1325648169.3037.84.camel@work-vm>
References: <1325648169.3037.84.camel@work-vm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 19:49:50 -0800
X-Google-Sender-Auth: cMjiiFu1tqrl3uwTPNWoKMVpTeA
Message-ID: <CA+55aFxybC2Y-EK4uFJUvj==8kkrokxJh-AWNCyo+9W+DdTw-Q@mail.gmail.com>
Subject: Re: RTC revert request
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, NeilBrown <neilb@suse.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        lkml <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 7:36 PM, john stultz <johnstul@us.ibm.com> wrote:
>
> Thus, would you please revert:
>
> 93b2ec0128c431148b216b8f7337c1a52131ef03
> rtc: Expire alarms after the time is set.
>
> and
>
> c0afabd3d553c521e003779c127143ffde55a16f
> rtc: Disable the alarm in the hardware

Ok, I picked up on the second revert already because of being cc'd on
the discussion about the stable tree.

Can you point me at the background for that first one, or write a
changelog for the revert for me? I don't want to have reverts without
background and explanation of them..

                     Linus
