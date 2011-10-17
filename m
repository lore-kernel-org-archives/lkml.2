Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1JQHJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:09:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48153 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1JQHI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:08:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E9BB353.70606@redhat.com>
References: <4E9BB353.70606@redhat.com>
Date: Mon, 17 Oct 2011 09:08:57 +0200
Message-ID: <CAN+gG=FsAwnQH-KjmLCvYpB_MVoe0zyBOLNu1zn3YwduC37p2A@mail.gmail.com>
Subject: Re: patch for Dell ST220T Touch Screen Monitor
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Gopal <gtiwari@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Glenn Sommer <gsommer@datanordisk.dk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gopal,

well, the device 0x1fd2:0x0064 is already supported by hid-multitouch
since mid-August. It has been included in the for-next branch of
Jiri's tree (see
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commit;h=c50bb1a4005630f47b5da26336f74a485033a515
).

As the device is a standard (Win7 compatible) hid multitouch device,
it's better to handle it that way: you'll get multitouch support and
there will be no cost to maintain it ;-)

Cheers,
Benjamin

On Mon, Oct 17, 2011 at 06:47, Gopal <gtiwari@redhat.com> wrote:
> Hello Everybody,
>
> We have recently created Support for Dell ST2220T Touch screen monitor with
> in the kernel hierarchy driver/input/touchscreen patch for this attach with
> this mail.
> Please find the attachment. I have previously also send the patch didn't got
> any feedback so sending it again.
>
> thanks
> Gopal
>
