Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0FFKqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:46:21 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43987 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab0FFKqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:46:20 -0400
Date: Sun, 6 Jun 2010 12:46:01 +0200
From: Florian Mickler <florian@mickler.org>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev?= =?ISO-8859-15?Q?=E5g?= 
	<arve@android.com>,
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
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100606124601.2f1f6714@schatten.dmk.lab>
In-Reply-To: <AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
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
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010 12:00:47 +0200
Vitaly Wool <vitalywool@gmail.com> wrote:

> Even worse, the suspend wakelock will keep the
> whole kernel active, as opposed to powering off unused devices
> separately as it's done in runtime PM. 

That is not true. While the kernel is not suspended it does
runtime pm.



> > Users do like that to work too -- I recall Arve leaving a device in
> > his filing cabinet with the radio off while he was out of the country
> > for three weeks once, and him discovering it was still running with
> > something like 25% battery remaining when he returned.
> 
> So what you're actually up to is that a user should restart the phone
> and turn the radio off if he wants to find it running when he's back
> from a long business trip or something. Nice...

?


Cheers,
Flo
