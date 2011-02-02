Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1BBVyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:54:54 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:49167 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754431Ab1BBVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:54:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABBhSU1Ld/sX/2dsb2JhbAAMhAvNW5A9gSeDN3UEhHg
X-IronPort-AV: E=Sophos;i="4.60,416,1291611600"; 
   d="scan'208";a="90370145"
Message-ID: <4D49D2AA.20201@teksavvy.com>
Date: Wed, 02 Feb 2011 16:54:50 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, kraxel@redhat.com
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <4D496AAC.1010106@canonical.com> <20110202165800.GB3178@core.coreip.homeip.net> <4D49B7D7.9020003@canonical.com>
In-Reply-To: <4D49B7D7.9020003@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-02-02 03:00 PM, Chase Douglas wrote:
> On 02/02/2011 11:58 AM, Dmitry Torokhov wrote:
>> On Wed, Feb 02, 2011 at 09:31:08AM -0500, Chase Douglas wrote:
>>> On 01/23/2011 12:03 PM, Mark Lord wrote:
>>>> As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
>>>> no longer work.  And if I grab newer/patched versions of those from the latest
>>>> Ubuntu 10.10, then those newer/patched versions do not work with kernels
>>>> *before* 2.6.36.
>>>
>>> I planned on taking another look at this before we release Ubuntu 11.04
>>> at the end of April. That doesn't prevent someone else from helping out
>>> :), but I'll make sure the utility is working again if not.
>>>
>>
>> Here you go:

That patch was not enough for me to get input-kbd working here on Ubuntu-10.10.
It would still only let me map 10 keys of my 56(?) button remote.

I also had to hack it to ignore the read-in map->size value when writing-out
the new keymap.

Cheers
