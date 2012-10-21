Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2JURwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:52:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56710 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab2JURwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:52:38 -0400
Message-ID: <50843661.9060707@ti.com>
Date: Sun, 21 Oct 2012 10:52:33 -0700
From: Tom Rini <trini@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Shin, Jacob" <Jacob.Shin@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur> <50833F30.4020802@ti.com> <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/12 21:01, Yinghai Lu wrote:
> On Sat, Oct 20, 2012 at 5:17 PM, Tom Rini <trini@ti.com> wrote:
>> On 10/20/12 17:11, Shin, Jacob wrote:
>>> Hi could you please attach the dmesg output? Before rc2 is fine as well.
>>> I would like to see the E820 table. Thank you,
>>
>> dmesg is quite long so I've put it on pastebin: http://pastebin.com/4eSPEAvB
>>
>> --
> 
> [    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000042fffffff] usable
> 
> pre-calculate table size is too small, so it crashes.
> 
> can you please try
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm
> 
> and post bootlog?

This boots but I'm bisecting another failure later on and can't post the
boot log (just finished bisecting that issue now).

-- 
Tom
