Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab0FFP0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:26:12 -0400
Received: from mail-yw0-f187.google.com ([209.85.211.187]:51648 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0FFP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LDheQr7XmqfnUNApDm5twDk8asRHibdMt82EcwHqCoTPTWELBuSns6SW1yPyC94v9O
         Vk8rMD6E+PVulFbdyJCJyGZHwSK7v5gKlgKcpQwN8XkGEnJQAluTzuQOkFEqe9dT8zp9
         7iFmPPfOboiQucZz4Cw2ipAUXIGuvvCXCE2kY=
MIME-Version: 1.0
In-Reply-To: <20100606133130.GA8513@srcf.ucam.org>
References: <1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
	<AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
	<20100606133130.GA8513@srcf.ucam.org>
Date: Sun, 6 Jun 2010 17:26:09 +0200
Message-ID: <AANLkTimXTgZS_fZQa8hjIptJrCn756gF_xakT1IQiLWa@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Vitaly Wool <vitalywool@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
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

2010/6/6 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Sun, Jun 06, 2010 at 12:00:47PM +0200, Vitaly Wool wrote:
>
>> Sure, but my point was, some non-trivial (still kind of natural for a
>> smartphone) activities with the device will prevent it from suspending
>> for quite some time. Even worse, the suspend wakelock will keep the
>> whole kernel active, as opposed to powering off unused devices
>> separately as it's done in runtime PM. Yep, I know about the "early
>> suspend" type of thing; yet it's excess, not mainlined and lacks
>> granularity.
>
> Holding a suspend blocker is entirely orthogonal to runtime pm. The
> "whole kernel" will not be "active" - it can continue to hit the same
> low power state in the idle loop, and any runtime pm implementation in
> the drivers will continue to be active.

Yeah, that might also be the case, But then again, what's the use of
suspend blockers in this situation?

~Vitaly
