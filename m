Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0FIDr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 23:47:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab0FIDr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 23:47:26 -0400
Date: Tue, 8 Jun 2010 20:46:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Florian Mickler <florian@mickler.org>, Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <alpine.DEB.2.01.1006081759150.17462@asgard.lang.hm>
Message-ID: <alpine.LFD.2.00.1006082042020.4506@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com> <1275653210.27810.39762.camel@twins> <AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com> <1275731653.27810.41078.camel@twins>
 <20100605092851.6ee15f13@infradead.org> <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com> <AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com> <AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
 <AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com> <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com> <AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com> <alpine.DEB.2.01.1006060305060.17462@asgard.lang.hm>
 <AANLkTinW-X5m85rUcqP-lrEdfBikVclJWgqiWDkpxnAc@mail.gmail.com> <20100606124949.539fa636@schatten.dmk.lab> <alpine.DEB.2.01.1006060410050.17462@asgard.lang.hm> <20100607141624.3d004db2@schatten.dmk.lab> <alpine.DEB.2.01.1006081759150.17462@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, david@lang.hm wrote:
> 
> having suspend blockers inside the kernel adds significant complexity, it's
> worth it only if the complexity buys you enough. In this case the question is
> if the suspend blockers would extend the sleep time enough more to matter. As
> per my other e-mail, this is an area with rapidly diminishing returns as the
> sleep times get longer.

Well, the counter-argument that nobody seems to have brought up is that 
suspend blockers exist, are real code, and end up being shipped in a lot 
of machines.

That's a _big_ argument in favour of them. Certainly much bigger than 
arguing against them based on some complexity-arguments for an alternative 
that hasn't seen any testing at all.

IOW, I would seriously hope that this discussion was more about real code 
that _exists_ and does what people need. It seems to have degenerated into 
something else.

Because in the end, "code talks, bullshit walks". People can complain and 
suggest alternatives all they want, but you can't just argue. At some 
point you need to show the code that actually solves the problem.

				Linus
