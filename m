Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab2JUEBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 00:01:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56405 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2JUEBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 00:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <50833F30.4020802@ti.com>
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur>
	<d556fc0f-da5d-4531-b331-6dc086461f34@blur>
	<50833F30.4020802@ti.com>
Date: Sat, 20 Oct 2012 21:01:43 -0700
X-Google-Sender-Auth: gQlsy5EqxN7kOBKdCftGApgznO4
Message-ID: <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on boot
From: Yinghai Lu <yinghai@kernel.org>
To: Tom Rini <trini@ti.com>
Cc: "Shin, Jacob" <Jacob.Shin@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 5:17 PM, Tom Rini <trini@ti.com> wrote:
> On 10/20/12 17:11, Shin, Jacob wrote:
>> Hi could you please attach the dmesg output? Before rc2 is fine as well.
>> I would like to see the E820 table. Thank you,
>
> dmesg is quite long so I've put it on pastebin: http://pastebin.com/4eSPEAvB
>
> --

[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000042fffffff] usable

pre-calculate table size is too small, so it crashes.

can you please try

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

and post bootlog?

Thanks

Yinghai
