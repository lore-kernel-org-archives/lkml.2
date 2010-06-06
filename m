Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab0FFLLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:11:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33617 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab0FFLLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B64AgAw9GIPWVnz8yzcm3BzOGnk6STxTqePc0zgZvsZFUMlLt/+AtdI0xN5ZjHq0nL
         zAl03HO6i/nYrNLT8KxieRCaQh3NPybQBvac1cjo/hCp86KBxhGxHgkgtlmigwUICHal
         c99KXvfQZAA0X2KnnhpUznJ+UrivKtz09EVio=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1006060235130.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
	<alpine.DEB.2.01.1006060235130.17462@asgard.lang.hm>
Date: Sun, 6 Jun 2010 14:11:50 +0300
Message-ID: <AANLkTinZdZdLgB7wqDx3jyyfBJdRryWkMP-iwwsY_W5l@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: david@lang.hm
Cc: Brian Swetland <swetland@google.com>, Vitaly Wool <vitalywool@gmail.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/6  <david@lang.hm>:
> On Sun, 6 Jun 2010, Brian Swetland wrote:
> if you could shrink the time awake to 0.01 second per wakeup you would shift
> this all up a category (and avoiding the need to wake everything up to
> service a timer would help do this)
>
> this effort very definantly has diminishing returns as you go to larger
> sleep periods as the constant standby power draw becomes more and more
> dominating. someone mentioned that they were getting the sleep time of
> normal systems up past the 1 second mark with the 10 second mark looking
> very attainable. that is where you get the most benifit for whatever changes
> are needed. getting up to a 2 min sleep time really gives you about all the
> benifit that you can get, going from there to 15 min makes very little
> difference.
>
> don't let chasing the best possible sleep time prevent you from considering
> options that would be good enough in time, but would drastically reduce the
> maintinance effort (as things could be upstreamed more easily), and would be
> usable on far more systems.

Not to mention the fact that there's nothing fundamental that prevents
dynamic PM to reach > 15 min idle. It's a matter of time before we
find the tools needed. The amount of work that suspend blockers would
require to implement properly in user-space other than Android just
doesn't match the power savings.

-- 
Felipe Contreras
