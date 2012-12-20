Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2LTR2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:28:25 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63709 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LTR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:28:19 -0500
MIME-Version: 1.0
X-Originating-IP: [95.195.142.226]
In-Reply-To: <CA+55aFxL47wxTyTzLdnoFV=trnrMAz=_7rhsQFjb+K_mvTCa9w@mail.gmail.com>
References: <20121220163814.GA29557@quad.lixom.net>
	<CA+55aFxL47wxTyTzLdnoFV=trnrMAz=_7rhsQFjb+K_mvTCa9w@mail.gmail.com>
Date: Thu, 20 Dec 2012 09:28:19 -0800
Message-ID: <CAOesGMiZTF4gogCkU7eSaOydkX82wfWywkKBgCJo_-ZW0Ox4kw@mail.gmail.com>
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, maxime.ripard@free-electrons.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[proper reply-to-all this time]

On Thu, Dec 20, 2012 at 8:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Dec 20, 2012 at 8:38 AM, Olof Johansson <olof@lixom.net> wrote:
>>
>> One of the sunxi patches from the last pull request was misapplied (I
>> realized what happened -- git am -s didn't apply cleanly so I had done it
>> through regular patch, thus not catching the renames properly). Here's
>> a fresh version of the pull request with a couple more OMAP and Samsung
>> patches included.
>
> Argh!
>
> I pulled your earlier branch due to Tony's ack, and now you're
> re-created that branch with new pulls (effectively rebasing it).
>
> Don't do things like this to me.

Yeah, sorry about that -- I wanted to replace the broken patch, and
Tony's branch was based on a newer version of your tree so I brought
everything forward as I had to rebase anyway.

I'll rebuild on top of what you've pulled, and send a fresh request of
just the delta. Sorry about the race condition here.


-Olof
