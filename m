Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2D1WVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 18:21:01 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:22216 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2D1WU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 18:20:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQEDI1UBEAsYAgIFFgsCAgkDAgECAUUGDQEHAQG0JIoYgS+OE4EYBKkl
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="177467301"
Message-ID: <4F9C6D4A.5080608@teksavvy.com>
Date: Sat, 28 Apr 2012 18:20:58 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru> <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com> <4F9A6ABA.6050503@msgid.tls.msk.ru> <4F9ABF90.5060404@teksavvy.com> <4F9B0378.70906@zytor.com>
In-Reply-To: <4F9B0378.70906@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-27 04:37 PM, H. Peter Anvin wrote:
> On 04/27/2012 08:47 AM, Mark Lord wrote:
>> On 12-04-27 05:45 AM, Michael Tokarev wrote:
>> ..
>>> Please note: the talk is about 32bit userspace on 64bit kernel,
>>> which should be quite rare these days, or something of less
>>> priority.
>>
>>
>> I suspect 32bit-PAE is more common than 32/64,
>> but both are valid and not uncommon in the wild.
> 
> 32-on-64 is a very important use case, because it lets us get people off
> 32-bit kernels.

Agreed.  But -PAE is even more important for the millions of people
with NVIDIA graphics controllers in their machines, or at least if
they want decent video playback.  :)

The otherwise-excellent NVIDIA drivers don't work in 32/64 mode,
but they do handle -PAE just fine.

Cheers
