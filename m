Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2DIPnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:43:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40747 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932069Ab2DIPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:43:34 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/ou28PHm7oWx8cxiuI0mBYMYZ/Ln/BggzzEqBKOy
	4gcWlNBfcd4lty
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<8762d9v10x.fsf@turtle.gmx.de>
	<CA+55aFy9TKbVEOsBCWUf4u3o5qojvLLj6bEV-fNqdK3_1ysp1w@mail.gmail.com>
Date: Mon, 09 Apr 2012 17:43:31 +0200
In-Reply-To: <CA+55aFy9TKbVEOsBCWUf4u3o5qojvLLj6bEV-fNqdK3_1ysp1w@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 9 Apr 2012 08:24:15 -0700")
Message-ID: <87hawsewrg.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-09 17:24 +0200, Linus Torvalds wrote:

> On Mon, Apr 9, 2012 at 12:04 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>>
>> While I did not experience any crashes or instabilities (yet?), I'm also
>> seeing memory leaks.  On a system started this morning, with hardly
>> anything running:
>
> Do you also have ANDROID support compiled in?  And
> ANDROID_LOW_MEMORY_KILLER in particular?

No, "grep ANDROID /boot/config-$(uname -r)" prints nothing.

Cheers,
       Sven
