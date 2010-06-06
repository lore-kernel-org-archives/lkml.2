Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab0FFLE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:04:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45750 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab0FFLE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sz7UUdubO2Vs+NvA/dR33kVpBEl5kkEaspl7RDOko5EO7ZgOAbs294OrlwSVYRixfG
         t1awd5p0xjDxgsZzAUT/d8YxXFJ0GOsd3SUZ1B3CHZATXcDZ/EQC0JkZmD7ouplzYtsn
         nY1V299DqjmM70b3PGbcyrKEngSrUmWwAtnc4=
MIME-Version: 1.0
In-Reply-To: <20100606124949.539fa636@schatten.dmk.lab>
References: <20100603193045.GA7188@elte.hu>
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
	<AANLkTinW-X5m85rUcqP-lrEdfBikVclJWgqiWDkpxnAc@mail.gmail.com>
	<20100606124949.539fa636@schatten.dmk.lab>
Date: Sun, 6 Jun 2010 12:57:10 +0200
Message-ID: <AANLkTin2ULTBRpTdX6rWuBOKCzPTFMMAJLz4NDUPb6al@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Vitaly Wool <vitalywool@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
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

2010/6/6 Florian Mickler <florian@mickler.org>:

> Suspend_blockers allow the system to suspend ("mem">/sys/power/state
> suspend), when the userspace decides that the device is not in use.

Sorry. What? Blockers allow the system to suspend?

> So implementing suspend_blockers support does not impact any
> optimizations done to either system A nor system B.

Suspend blockers by themselves are of no use. Completely. So any talks
on suspend blockers separated from the sleep policy are completely
pointless.
The suspend blockers are of use when the userspace tries to blindly
freeze the tasks to enter the suspend state. This way of hammering the
system down obviously impacts everything.

~Vitaly
