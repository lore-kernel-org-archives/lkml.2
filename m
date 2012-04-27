Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab2D0Uhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:37:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40205 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2D0Uhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:37:50 -0400
Message-ID: <4F9B0378.70906@zytor.com>
Date: Fri, 27 Apr 2012 13:37:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru> <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com> <4F9A6ABA.6050503@msgid.tls.msk.ru> <4F9ABF90.5060404@teksavvy.com>
In-Reply-To: <4F9ABF90.5060404@teksavvy.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 08:47 AM, Mark Lord wrote:
> On 12-04-27 05:45 AM, Michael Tokarev wrote:
> ..
>> Please note: the talk is about 32bit userspace on 64bit kernel,
>> which should be quite rare these days, or something of less
>> priority.
> 
> 
> I suspect 32bit-PAE is more common than 32/64,
> but both are valid and not uncommon in the wild.

32-on-64 is a very important use case, because it lets us get people off
32-bit kernels.

	-hpa

