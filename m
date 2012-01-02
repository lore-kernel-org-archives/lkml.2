Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2ABWDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:03:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33822 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABWDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:03:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120102215028.GA15701@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org> <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 14:03:27 -0800
X-Google-Sender-Auth: mb0_NUWkSs2xfqKHmXW98DW2nl4
Message-ID: <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 1:50 PM, Matthew Garrett <mjg@redhat.com> wrote:
> On Mon, Jan 02, 2012 at 01:27:03PM -0800, Linus Torvalds wrote:
>
>> If we didn't load the firmware before the suspend, then the resume
>> function of a device sure as hell had better not load it at resume
>> time either.
>
> If the hardware has lost its state then refusing to load the firmware at
> resume time isn't going to leave you with a working device.

What the heck is your problem?

Go back and read it.

If it wasn't loaded before, THEN IT WASN'T WORKING BEFORE EITHER! And
if it was loaded before, then it would be cached (and thus trivially
reloaded without having to invoke user-space or disk devices that may
not be running) and thus loading it would work.

So regardless of the state before, it would resume "correctly" - in
the same state it was suspended. In other words: a caching firmware
loader would have done EXACTLY THE RIGHT THING.

Why the hell do you keep on harping on idiotic issues? Stop being a
moron, just repeat after me:

   A caching firmware loader fixes all these issues

and is simple to boot. Stop the idiotic blathering already.

                    Linus
