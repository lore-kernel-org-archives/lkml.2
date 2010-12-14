Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab0LNRZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:25:16 -0500
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:21151 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756148Ab0LNRZO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:25:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=V89VdFYGTXpLWCxDiTTEBQe1l81rZTRv6AgE3bvLsi+zJddm/3Q2Tc664UZTxFgd8E7oqWU0s37HYFb2RlGUC6aU3MRfvK9ArdlWooOGqfpErGrhExXfrdKIs4RcEcsJvjPSuSA1QTJ1aMJ5TUGzZYBRLFO7zS93y+gqM15KA4o=;
Message-ID: <865543.43677.qm@web31802.mail.mud.yahoo.com>
X-YMail-OSG: fK8tJTIVM1mR1YBEOJpUHjKMF6hSkcADeaWHGMtBhDbnEIr
 wF7HGD3dqbjEVzRfLMev_RFfM0iF8SLL7NS.tqsW11ic_8E5PAJdDl4gAlAF
 TB55SwMhSUm1jZvrN60T9N9xTD4YAr5khS0EPD70.rYfdx6niFXnl.cMCbvB
 eVcEkqO3tfbWIkAiKLSCVTCNoF5oWIUnOG37r4vJVX9s8t8Y_u8ADbzIBJzf
 MtH_ZBDB3y9FyWNMxW72SGMOjUttrFaGHlEwBSGz.fO8OusRy5.Fij3X3LRh
 MIFCfrpiee8zT8RyGZLvAX6dTiAk6YvrHwGGyOOoh_2wqjIXFmMmiDB4I1.5
 sLcC7WhPWYZvKX5gsDOwK8TFm5QsKgK_Z8FaucLNOdhaj16qSM5yss9QJkOH
 _DjpnEvtX2es-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Tue, 14 Dec 2010 09:25:12 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/13/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> Your insinuations against the character of many
> long-standing Linux
> developers, based on their refusal to accept your
> submission,

No, not submission. The fact is that no one bothered to review the code. It was simply flat out NAK-ed it in just four minutes, fronting one of their co-workers with the defunct driver already in.

It would've been a different story if Greg, Alan and you and anyone else willing, had provided a technical review, and /then/ reject it--the rejection reason would've been clearer to everyone, than taking all this thread to get to.

Greg didn't review it and rejected it 4 minutes after posting. Alan didn't review it and after I posted the 18 technical reasons (my 2nd post in this thread replying to Greg's) said this:
> Your driver may be the best on the planet - who knows - 
Obviously he didn't review it.
You, after I posted the driver and the 18 technical reasons, said this:
> If, in fact, Luben's driver is somehow "better", ...
and
> ... several things would have to be true.  I do not know if they are true here, ...
and
> That said, unless the current driver is really bad, and Luben's is tremendously better,

These are from this very thread.

> are simply
> beyond the pale.  I could just as easily make every
> one of these
> accusations against you -- who pays your salary, for
> example?  What are
> their interests?  You make claims about your
> motivations, but how am I to
> verify any of those?

I've already stated that there had never been an agenda about uasp.c and Linux. The uasp.c driver was written over most of a Saturday (when I had time and uas.c showed itself to be defunct).  Since uasp.c is a working driver and correctly implemented in terms of UAS, USB, SCSI, the kernel and it's layers, I thought it would be *helpful* and *useful* to people--that's all.

The driver was rejected flat out only after 4 minutes after submission claiming that there is a driver in the kernel that "does the exact same thing".  I then provided 18 technical reasons as to why uas.c does NOT in fact do the exact same thing to which Greg responded with:

> But again, this driver is not acceptable as-is, sorry.

Why would he have to apologize? Anyway, to which you responded with not knowing which driver is good.

> The linux community works because it is exactly that -- a
> community.  We
> have, just like any other community, standards of
> decorum.  You have
> violated those standards, repeatedly, despite several
> people politely
> telling you the proper manner in which to behave.

When people read "the community" responses in these mailing lists, they think "Wow what a benevolent bunch of people" and "look, they just wanna help". But what this mailing list doesn't show is that this is a very close knit of people who work for the same company (or two) and who go to Linux conferences religiously and are very close buddies. Obviously uasp.c didn't stand a chance _and_ was rejected in just 4 minutes, without a technical review. As you can see in this thread the three of you kept fronting the uas.c driver despite the 18 technical reasons I posted and the fact that it's badly written, and needs to be replaced with something that works, as people will find out when UAS devices make it to market. It's all in the beginning of this thread, start reading here:
http://marc.info/?t=129165521000011&r=2&w=2

So after such a blatant refusal to even give a technical review of the driver, it had me thinking: why would that be?

> > Did you review my driver? Did anyone else in this
> thread? No, of course
> > not. You didn't even do it the second time I called
> your bluff in this
> > thread. Why not? Simple, it's not what you're getting
> paid to do now.
> 
> *bzzt*  Wrong.  I did review your driver.  I
> found it interesting, but upon
> first submission I found no compelling reason to prefer it
> over the old.
> Your initial submission gave no such reasons.

If you reviewed it, then why did you write that you had no idea if the driver were good or not? Here is what you wrote in this very thread:

> If, in fact, Luben's driver is somehow "better", ...
and
> ... several things would have to be true.  I do not know if they are true here, ...
and
> That said, unless the current driver is really bad, and Luben's is tremendously better,

Your full message can be found here: http://marc.info/?l=linux-kernel&m=129186163519728&w=2.

But now you say that you had reviewed it!? Now you say you found the driver "interesting" but "no compelling reason to prefer it over the old". How about that it works? How about the 18 technical reasons I posted *before* you posted your response quoted above (which reasons you had read)?  You didn't address any of them.

> It was only until, after your submission was refused,

It was flat out refused only 4 minutes after I submitted it.

> that
> you addressed
> the technical merits of your driver over the existing
> one.

The reason I posted the 18 technical reasons, is because Greg claimed that uas.c "does the exact same thing". His response is here: http://marc.info/?l=linux-usb&m=129165544600441&w=2, he posted this only 4 minutes after I posted the driver. I therefore decided to clarify that uas.c does NOT in fact do the "exact same thing", and backed that up with the 18 technical points.

> I will admit,
> you have some valid technical points.  But, they are
> completely overridden
> by your inability to work within the standards of behavior
> of the community.

What does this actually mean? I just posted my uasp.c driver in this very thread and it got rejected 4 minutes afterwards without technical review. When I followed up with a technical review you say "your inability to work within the standards of behavior of the community".

Does providing no technical review and flat out rejecting a driver fall into your "inability to work within the standards of behavior of the community" definition?

> If, at any time, you had decided to stop using ad-hominem
> attacks and
> instead made a calm, composed, and well-reasoned statement
> about why the
> work to fixup the existing driver would be worse than doing

1. The whole thing should be ripped out. Any good work would change 100% of the driver as uasp.c shows (essentially getting a new driver in).
2. I did make that "statement" in the 18 technical reasons of why uasp.c was better than uas.c, other than "it works" of course.

> a drop-in
> replacement, we would have listened.

I did. In the 18 technical reasons I listed in this very thread. Here is the link: http://marc.info/?l=linux-kernel&m=129185378712222&w=2

> You came pretty
> close to doing this,
> but seemed completely unable to resist personal attacks
> against members of
> this community.

And those are? I think you're priming up here what people should think.

> And you never really addressed,
> beyond a 1-line statement
> stating that to fixup the existing driver you would need to
> replace it
> wholesale, why working to improve the existing driver is a
> bad choice.

I said that in the 18 technical reasons I listed, link above.  The existing driver is badly written, the infrastructure is just off.

> We look to submitters to maintain their work.  Yes,
> there are apparently
> some difficulties getting Matt W. to push the ball forward
> on his UAS
> driver.

It's simple, rip out uas.c and put in uasp.c and give people something working and let everyone contribute to something with good foundation.

> However, dealing with you is comparable to
> drinking napalm; I
> would much rather deal with someone who is
> less-than-responsive rather than
> someone who is abrasive.

Actually, it's very easy to deal with me. When people come to me, I say "What can I do to help you?" and then I provide them a solution and always go the extra mile, and give them something constructive they can use, and I say, "here it is, and I did this extra thing and let me know what else I can do for you."  Most of the time I don't wait for people to come to ask me, but proactively contribute to the end goal, surprising people with "it's already done" when they ask for it.

   Luben

