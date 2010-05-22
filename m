Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0EVDwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 23:52:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45032 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0EVDwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 23:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dqpvfMHm+lXkN5XnZKwmrp8jmd+Fo5xr4pQf5RtfX5abvCuVgxCuyYsDJKsXNz7i5A
         JP5z8tQOaCHGYmylms7AMUqnhgcS2BpkwZCL7vDKA/aVNe+/B9YEHwvTWXUOtRQVBd+V
         4wHWNEHpU1i0qKbdFzncHyxxha4A5/nSXoihU=
MIME-Version: 1.0
In-Reply-To: <4BF6C7B6.2020008@euromail.se>
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>
	 <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>
	 <4BF6B673.1080507@euromail.se>
	 <20100521165218.GA26439@core.coreip.homeip.net>
	 <4BF6BB43.2020405@euromail.se>
	 <20100521172222.GB26439@core.coreip.homeip.net>
	 <4BF6C303.7030804@euromail.se>
	 <20100521174140.GA23155@core.coreip.homeip.net>
	 <4BF6C7B6.2020008@euromail.se>
Date: Fri, 21 May 2010 20:52:31 -0700
Message-ID: <AANLkTikzH7IscIAYGNw00fjXSYJosaaAsbUArt9M7wfJ@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 10:49 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Dmitry Torokhov wrote:
>>
>> I guess this is where our disconnect lies as when I am looking at the
>> event names I view all *_MT_* events as related to the multitouch
>> protocol handling.
>>
>
> Yes. It is true that slot control is MT related, but I am looking at this from
> the perspective of future expansions like KEY_MT,  KEY_REL, and such, finding a
> way to signal to user space which events are handled via slots. If we had
> ABS_MT_SLOT, we would most likely get applications which store ABS_MT_SLOT as an
> attribute of the slot together with ABS_MT_POSITION_X, ABS_MT_TOUCH_MAJOR, etc,
> which is just not right.

Why is it not right?  Do you mean ABS_SLOT can be used as a label for
both _MT_ and non _MT_ events while ABS_MT_SLOT can not?

> So the proposal is ABS_SLOT.

I haven't convinced myself with this proposal yet. Can you explain the
difference between ABS_SLOT and ABS_MT_SLOT with a concrete example?
Fool always ignores Mark Twain's advice, you know :).

Ping
