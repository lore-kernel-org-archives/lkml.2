Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0FFKTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:19:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60230 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0FFKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iVtY0eBBsboVGRZ0QYGcnauXd9vRnPxalxajan6mp6V9kLl7N71POfzNMnzEqRG/uz
         5aXLjJvpVLc/GrSP5h0YhHGm7MhKqnMkX+AWwOvKtqYbDPcKNHQq2+eRfOtrXprkKhpI
         dx31x5fC2AzyU6C48A6SpPBe0+D70UvoP1Qs8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1006060305060.17462@asgard.lang.hm>
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
	<AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
	<alpine.DEB.2.01.1006060305060.17462@asgard.lang.hm>
Date: Sun, 6 Jun 2010 12:19:08 +0200
Message-ID: <AANLkTinW-X5m85rUcqP-lrEdfBikVclJWgqiWDkpxnAc@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Vitaly Wool <vitalywool@gmail.com>
To: david@lang.hm
Cc: Brian Swetland <swetland@google.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/6  <david@lang.hm>:

> as an example (taken from this thread).
>
> system A needs to wake up to get a battery reading, store it and go back to
> sleep, It does so every 10 seconds. But when it does so it only runs the one
> process and then goes back to sleep.
>
> system B has the same need, but wakes up every 10 minutes. but when it does
> so it fully wakes up and this allows the mail app to power up the radio,
> connect to the Internet and start checking for new mail before oppurtunistic
> sleep shuts things down (causing the mail check to fail)
>
> System A will last considerably longer on a battery than System B.

Exactly, thanks for pointing out the specific example :)

~Vitaly
